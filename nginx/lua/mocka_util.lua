local http_util = require "mocka.http_util"
local cjson = require "cjson"
local MockaUtil = {}

function MockaUtil:pollUntilSuccess(fn, success)
    local ok = success(fn())
    while not ok do
        success(fn())
    end
end

function MockaUtil:countSubstring(s1, s2)
    return select(2, s1:gsub(s2, ""))
end

--[[
    Capture the os execution output - can be either raw or not
]]--
function MockaUtil:osCapture(cmd, raw)
    raw = raw or false
    local handle = assert(io.popen(cmd, 'r'))
    local output = assert(handle:read('*a'))

    handle:close()

    if raw then
        return output
    end

    output = string.gsub(
            string.gsub(
                    string.gsub(output, '^%s+', ''),
                    '%s+$',
                    ''
            ),
            '[\n\r]+',
            ''
    )

    return output
end
--- size is in kb
function MockaUtil:generatePayload(size, type)
    type = type or "dd"
    local bs = 1
    local count = 1024
    if size == "100m" then
        bs = bs * 102400
    elseif size == "10m" then
        bs = bs * 10240
    elseif size == "1g" then
        bs = bs * 1048576
    elseif size == "1m" then
        bs = bs * 1024
    elseif size == "1k" then
        bs = bs * 1
    else
        bs = tonumber(size)
        count = 1
    end
    local filename = "/var/tmp/client_body_temp/" .. size
    local file = io.open(filename, "w")
    file:write("")
    file:close()
    local cmd
    if type == "dd" then
        cmd = "dd if=/dev/urandom of=" .. filename .. " count=" .. count .. " bs=" .. bs
    elseif type=="base64" then
        cmd = "base64 /dev/urandom | head -c " .. tostring(bs * count) .. " > " .. filename
    end
    os.execute(cmd)
    local content = MockaUtil:readFile(filename)
    os.remove(filename)
    return content
end

function MockaUtil:readFile(path)
    local file = io.open(path, "rb")
    if not file then
        return nil
    end
    local content = file:read "*a"
    file:close()
    return content
end

function MockaUtil:writeFile(path, data)
    local file = io.open(path, "wb")
    if not file then
        return nil
    end
    file:write(data)
    file:close()
end

function MockaUtil:fileExists(path)
    local file = io.open(path, "r")
    if not file then
        return false
    end
    file:close()
    return true
end

function MockaUtil:deleteKeyFromLocalCache(sharedDict, key)
    ngx.shared[sharedDict]:delete(key)
end

function MockaUtil:deleteAllEntriesFromLocalCache(sharedDict)
    ngx.shared[sharedDict]:flush_all()
end

function MockaUtil:getKeyFromLocalCache(sharedDict, key)
    return ngx.shared[sharedDict]:get(key)
end

function MockaUtil:setKeyInLocalCache(sharedDict, key, value)
    ngx.shared[sharedDict]:set(key, value)
end

function MockaUtil:gw_wait_for_logs(substring, timeout)
    timeout = timeout or 30
    os.execute('timeout '..timeout..' tail -n0 -f /var/log/nginx/error.log | while read LOGLINE; do [[ "${LOGLINE}" == *"'..substring..'"* ]] && echo $LOGLINE && pkill -P $$ tail; done')
end

function MockaUtil:gw_get_worker_pid()
    self:gw_wait_fork()

    -- Get the youngest worker
    local pid = MockaUtil:osCapture("ps -ef | grep 'nginx: worker' | grep -v grep | expand | tr -s ' ' | cut -d ' ' -f2 | sort -nr | head -1")
    ngx.log(ngx.INFO, "Worker PID=" .. tostring(pid))

    -- log process info
    ngx.log(ngx.INFO, "Nginx processes: ", MockaUtil:osCapture("echo $(ps -ef | grep 'nginx: ' | grep -v grep | expand | tr -s ' ' | cut -d ' ' -f2,8,9 | tr '\n' ';')"))

    return pid
end

function MockaUtil:gw_wait_worker_pid_exit(pid)
    -- wait for pid to exit
    os.execute("timeout 120 sh -c 'while kill -0 "..tostring(pid).."; do sleep 0.5;  done'")
    ngx.log(ngx.INFO, "Worker exited PID=" .. tostring(pid))

    -- log process info
    ngx.log(ngx.INFO, "Nginx processes: ", MockaUtil:osCapture("echo $(ps -ef | grep 'nginx: ' | grep -v grep | expand | tr -s ' ' | cut -d ' ' -f2,8,9 | tr '\n' ';')"))
end

function MockaUtil:gw_wait_workers(count)
    self:gw_wait_fork()

    -- work for workers count
    os.execute("timeout 120  sh -c 'until [ `ps -ef | grep \"nginx: worker\" | grep -v grep | wc -l` -eq "..tostring(count).." ]; do sleep 0.5;  done'")

    -- log process info
    ngx.log(ngx.INFO, "Nginx processes: ", MockaUtil:osCapture("echo $(ps -ef | grep 'nginx: ' | grep -v grep | expand | tr -s ' ' | cut -d ' ' -f2,8,9 | tr '\n' ';')"))

    -- wait a bit, once the worker changes its prg_name, it might not instantly accept requests
    -- and cleanup local connection pool in case of any open sockets on client side
    local run_count = 0
    local res
    repeat
        res = http_util:request("127.0.0.1", 9191):path("/version"):header("Connection", "Close"):get()
        if (res == nil) then ngx.sleep(0.5) end
        run_count = run_count + 1
    until res ~= nil or run_count > 20
end

function MockaUtil:gw_reload()
    os.execute('/usr/local/openresty/bin/nginx -s reload;')
end

function MockaUtil:gw_wait_fork()
    -- wait for api-gateway reload to execute if any in progress
    os.execute("timeout 120  sh -c 'until [ `ps -ef | grep \"api-gateway -s reload\" | grep -v grep | wc -l` -eq 0 ]; do sleep 0.5;  done'")
    -- wait until forked process is marked as slave
    os.execute("timeout 120  sh -c 'until [ `ps -ef | grep \"nginx: master\" | grep -v grep | wc -l` -eq 1 ]; do sleep 0.5;  done'")
    -- log process info
    ngx.log(ngx.INFO, "Nginx processes: ", MockaUtil:osCapture("echo $(ps -ef | grep 'nginx: ' | grep -v grep | expand | tr -s ' ' | cut -d ' ' -f2,8,9 | tr '\n' ';')"))
end

local charset = {}

do
    -- [0-9a-zA-Z]
    for c = 48, 57 do
        table.insert(charset, string.char(c))
    end
    for c = 65, 90 do
        table.insert(charset, string.char(c))
    end
    for c = 97, 122 do
        table.insert(charset, string.char(c))
    end
end


function MockaUtil:getRandomString(length)
    if not length or length <= 0 then
        return ''
    end
    math.randomseed(os.clock() ^ 5)
    return MockaUtil:getRandomString(length - 1) .. charset[math.random(1, #charset)]
end

return MockaUtil

local function norm_path(p)
    return (p:gsub("\\", "/"):gsub("^%.", ""):gsub("^/", ""):gsub("/", "."):gsub("%.lua$", ""))
end

local function read_key(arg, i)
    if arg[i]:sub(1, 1) ~= "-" or #arg[i] == 1 then
        return nil, arg[i], i + 1
    end

    if arg[i]:sub(2, 2) == "-" then
        local key, value = arg[i]:match("^%-%-([^=]+)=(.*)$")
        if key then
            return key, value, i + 1
        else
            return arg[i]:sub(3), arg[i + 1], i + 2
        end
    else
        local key = arg[i]:sub(2, 2)
        local value = arg[i]:sub(3)
        if #value == 0 then
            i = i + 1
            value = arg[i]
        elseif value:sub(1, 1) == "=" then
            value = value:sub(2)
        end
        return key, value, i + 1
    end
end

return {
    read_key = read_key,
    norm_path = norm_path
}


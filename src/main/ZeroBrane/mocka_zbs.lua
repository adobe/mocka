dofile 'interpreters/luabase.lua'
local MockaTests = {}
MockaTests.api = {
  test = {
    type = "function",
    description = "test fn",
    args = "(filename: string, fn: function, [, test_failure: boolean])",
    returns = "(nil)"
  }
}
MockaTests.imgList = ide:CreateImageList("MOCKA","RUN-NOW")
MockaTests.interpreter = MakeLuaInterpreter()
MockaTests.runTestId = ID("mocka.bar.runtest")
MockaTests.runTestIdFilePopup =  ID("mocka.file.runtest")
MockaTests.testFile = nil
MockaTests.bitmaps = {
  testIcon = ide:GetBitmap("RUN-NOW", "MOCKA", wx.wxSize(16,16))
}

function MockaTests:addMenuItem(menu, id, label, icon, where, event, fn)
  local menuItem = menu[where](menu, id, label)
  menuItem:SetBitmap(icon)
  ide:GetMainFrame():Connect(id, event, fn)
  return menuItem
end

function MockaTests:addTool()
  local tb = ide:GetToolBar()
  tool = tb:AddTool(runTestId, "Run test"..KSC(runTestId), bitmap)
  --tool:Toggle(false)
  tb:Realize()
end

function MockaTests:runTestForFile(testFile)
    ide:ExecuteCommand(
      'mocka ' .. self.testFile, 
      ide:GetProject(), 
      function(s) 
        ide:GetOutput():Write(s) 
      end
    )
end

function MockaTests:appendMockaToolbar()
  local menu = ide:GetMenuBar()
  local menuBar = wx.wxMenu()
  
  --- inserting the run test button
  self.runTestButton = self:addMenuItem(
    menuBar, 
    self.runTestId,
    "Run test",
    self.bitmaps.testIcon,
    "Append",
    wx.wxEVT_COMMAND_MENU_SELECTED,
    function()
      self:runTestForFile()
    end
  )
  self.runTestButton:Enable(false)
  if (self.testFile) then
    self.runTestButton:Enable(true)
  end
  
  menu:Append(menuBar, "Mocka")
end

function MockaTests:onRegister(this)
  MockaTests:appendMockaToolbar()
  ide:AddAPI("lua", "mocka", self.api)
  self.interpreter.name = "Lua5.1 - extended"
  self.interpreter.api = {"baselib", "mocka", "wxwidgets", "luajit2"}
  ide:AddInterpreter("mocka", self.interpreter)
end

function MockaTests:onUnRegister(this)
  ide:RemoveAPI("lua", "mocka")
  ide:RemoveInterpreter("mocka")
end

function MockaTests:fileExists(file)
  local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end

function MockaTests:isdir(path)
   -- "/" works on both Unix and Windows
   return self:fileExists(path.."/")
end

function MockaTests:search(file, txt)
  if(not file:find("%.lua")) then
    return false
  end
  if self:isdir(file) then
    return false
  end
  if not self:fileExists(file) then return false end
  for line in io.lines(file) do 
    local start, _ = line:find(txt, 1)
    if(start) then
      return true
    end
  end
  return false
end

function MockaTests:enableRunTestMenu(filePath)
  if not filePath then
    return
  end
  local exists = self:search(filePath, "test%(")
  if(exists) then
    self.testFile = filePath:gsub(ide:GetProject(), "")
    self.runTestButton:Enable(true)
  else
    self.testFile = nil
    self.runTestButton:Enable(false)
  end
end

function MockaTests:onEditorLoad(this, editor)
  local doc = ide:GetDocument(editor)
  self:enableRunTestMenu(doc:GetFilePath())
end

function MockaTests:onEditorFocusSet(this, editor)
  local doc = ide:GetDocument(editor)
  self:enableRunTestMenu(doc:GetFilePath())
end

function MockaTests:onFiletreeLDown(this, tree, event, item)
  self:enableRunTestMenu(tree:GetItemFullName(item))
end

function MockaTests:onMenuFiletree(this, menu, tree, event)
  if self.testFile then
    local item = self:addMenuItem(
        menu, 
        self.runTestIdFilePopup, 
        "Run test", 
        self.bitmaps.testIcon, 
        "Prepend", 
        wx.wxEVT_COMMAND_MENU_SELECTED,
        function()
          self:runTestForFile()
        end
      )
      item:Enable(true)
  end
end

local plugin = {
  name = "mocka_zbs",
  description = "Mocka ZeroBrane plugin",
  version = 0.1,
  onRegister = function(...) 
    MockaTests:onRegister(...) 
  end,
  onUnRegister = function(...) 
    MockaTests:onUnRegister(...) 
  end,
  onEditorLoad = function(...)
    MockaTests:onEditorLoad(...)
  end,
  onEditorFocusSet = function(...)
    MockaTests:onEditorFocusSet(...)
  end,
  onFiletreeLDown = function(...)
    MockaTests:onFiletreeLDown(...)
  end,
  onMenuFiletree = function(...)
    MockaTests:onMenuFiletree(...)
  end
}

local sts, inst = pcall(require, "mocka.argparse")
if sts and inst then
  return plugin
end

ide:Print(string.format([[
  mocka_sts needs `mocka` plugin.
  Please install with `luarocks install mocka`
]], inst))

return nil

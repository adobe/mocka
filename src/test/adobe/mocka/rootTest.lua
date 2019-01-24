local go = require "work.go"

test('should work relative to project root', function()
    assertEquals(true, go.run())
end)
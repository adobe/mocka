package = "mocka"
version = "1.0-1"
local function make_plat(plat)
    return { modules = {
        mocka = "src/main/lua/com/adobe/test/framework/Mocka.lua"
    } }
end
source = {
    url = "..."
}
build = {
	type = "builtin",
	platforms = {
		unix = make_plat("unix"),
		macosx = make_plat("macosx"),
		haiku = make_plat("haiku"),
		win32 = make_plat("win32"),
		mingw32 = make_plat("mingw32")
	}
}
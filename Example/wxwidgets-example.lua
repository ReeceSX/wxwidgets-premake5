local setup      = require("boilerplateProject")

-- TODO: make your own config and directory to house custom configs in
local configPath = "../wxConfig/"

local gl             = true
local net            = true
local path           = "./wxWidgets/"
local gtk_linux      = _G.linux  
local windows        = _G.win32
local wxGlobals      = {"__WX__", "wxUSE_GUI=1", "wxUSE_BASE=1","_FILE_OFFSET_BITS=64"}
local platform_macro = "__WXUNKNOWNPLATFORM_"
local wxvars         = {}

if (windows) then
	platform_macro = "__WXMSW__"
	wxvars = require("wxwidgets-windows-msw")
elseif (gtk_linux) then
	platform_macro = "__WXGTK__"
	wxvars = require("wxwidgets-linux-gtk")
end

table.insert(wxGlobals, platform_macro)

local addSources = function (name)
	local sourceFiles = wxvars[name]
	if (sourceFiles ~= nil) then
		for i,v in ipairs(sourceFiles) do 
			files(path .. v)
		end
	end
end

local includeBaseGtk = function()
	includedirs "/usr/include/gtk-3.0"
	includedirs "/usr/include/gdk-pixbuf-2.0"
	includedirs "/usr/include/glib-2.0"
	includedirs "/usr/include/pango-1.0/"
	includedirs "/usr/include/cairo"
	includedirs "/usr/lib/glib-2.0/include"

	_G.includeProject "AuroraFreetype" 
	_G.includeProject "AuroraHarfbuzz"
end

function setupWxWidgets( ... )
	local incDep = _G.includeProject

	-- aurorawxregex
	setup("AuroraWxRegex", "StaticLib", nil, path .. "include")
	defines(platform_macro)
	local regexFiles = 
	{
		path .. "src/regex/regcomp.c", 
		path .. "src/regex/regexec.c",
		path .. "src/regex/regerror.c",
		path .. "src/regex/regfree.c"
	}
	files (regexFiles)
	includedirs(path .. configPath)

	-- aurorascintilla
	setup("AuroraScintilla", "StaticLib", path .. "src/stc/scintilla/src",  path .. "src/stc/scintilla/include")
	defines({"__WX__", "SCI_LEXER", "NO_CXX11_REGEX", "LINK_LEXERS", platform_macro, "_FILE_OFFSET_BITS=64"})

	includedirs(path .. "include/")
	includedirs(path .. configPath)
	includedirs(path .. "src/stc/scintilla/src")
	includedirs(path .. "src/stc/scintilla/lexlib/")
	includedirs(path .. "src/stc/scintilla/lexers/")

	addSources("STC_SRC")

	if (gtk_linux) then
		includedirs "/usr/include/libmount"
		includedirs "/usr/include/atk-1.0"
		
		includedirs("gdk/include")

		includeBaseGtk()
	end

	-- aurorawxwidgets
	setup("AuroraWxWidgets", "StaticLib", nil, path .. "include")
	defines(wxGlobals)


	defines "WXBUILDING"

	links  "AuroraWxRegex"
	incDep "AuroraScintilla" 
	incDep "AuroraZLib" 
	incDep "AuroraPng"  

	includedirs(path .. "src/common/")
	includedirs(path .. "src/regex/")
	includedirs(path .. "src/stc/scintilla/include/")

	includedirs(path .. configPath)
	print (path .. configPath)

	if (gtk_linux) then
		-- CPP abis are violate and heavily implementation defined
		-- on the otherhand, C rarely differs between compilers much less compiler families and oses
		-- C is well represented in msft and sysv. there are no system abi conflicts, struct defs dont change, 
		--  calling conventions don't alter over time, and name wrangling stays constant. 
		-- we can safely import the OS's global headers when we get into Cs territory
		includeBaseGtk()
		
		includedirs "/usr/include/gio-unix-2.0"
		includedirs "/usr/include/dbus-1.0"
		includedirs "/usr/include/at-spi-2.0 " 
		includedirs "/usr/lib/dbus-1.0/include"
		includedirs "/usr/include/libsecret-1"
		includedirs "/usr/include/libmount"
		includedirs "/usr/include/atk-1.0"
		includedirs "/usr/include/at-spi2-atk/2.0"
	else
	end

	--addSources("XML_SRC") -- No build scripts for LibXPat on Windows for now

	addSources("CORE_SRC")
	addSources("BASE_SRC")
	addSources("BASE_AND_GUI_SRC")
	addSources("BASE_PLATFORM_SRC")


	if (net) then
		addSources("NET_PLATFORM_SRC")
		addSources("NET_SRC")
	end

	if (gl) then
		addSources("OPENGL_SRC")
	end
end

return {
	setupWxWidgets = setupWxWidgets,
	wxGlobals = wxGlobals,
	includeBaseGtk = includeBaseGtk
}
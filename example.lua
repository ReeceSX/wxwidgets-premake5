-- Auroras external source premake script for wxWidgets
-- Intended to use internal apis from the root source directory (not Build_Scripts, due to a bug in includeProject)
-- Other projects should adapt from this
-- The `setup` function contains boilerplate such as 'project', cppdielect, language, common includes, common defintions, etc 
-- `includeProject` add a dependency given an internal aurora name 
-- `path` defines the source root

local setup     = require("boilerplateProject")

local gl         = true
local path      = "Vendor/Graphics/wxWidgets/"
local gtk_linux = _G.linux  
local windows   = _G.win32

local platform_macro = "whatFuckingBullshit"
local wxvars  = {}

if (windows) then
	platform_macro = "__WXMSW__"
	wxvars = require("wxwidgets-windows-msw")
elseif (gtk_linux) then
	platform_macro = "__WXGTK__"
	wxvars = require("wxwidgets-linux-gtk")
end

function addSources(name)
	local sourceFiles = wxvars[name]
	if (sourceFiles ~= nil) then
		for i,v in ipairs(sourceFiles) do 
			files(path .. v)
		end
	end
end

local incDep    = _G.includeProject

function includeBaseGtk()
	includedirs "/usr/include/gtk-3.0"
	includedirs "/usr/include/gdk-pixbuf-2.0"
	includedirs "/usr/include/glib-2.0"
	includedirs "/usr/include/pango-1.0/"
	includedirs "/usr/include/cairo"
	includedirs "/usr/lib/glib-2.0/include"
end

-- aurorawxregex
setup("AuroraWxRegex", "StaticLib")
defines "__WXGTK__"
files ({path .. "src/regex/regcomp.c", path .. "src/regex/regexec.c", path .. "src/regex/regerror.c", path .. "src/regex/regfree.c"})
includedirs(path .. "include/")
includedirs(path .. "src/common/")
includedirs(path .. "lib/wx/include/gtk3-unicode-static-3.1/")

-- aurorascintilla
setup("AuroraScintilla", "StaticLib")
defines({"__WX__", "SCI_LEXER", "NO_CXX11_REGEX", "LINK_LEXERS", platform_macro, "_FILE_OFFSET_BITS=64"})

files(path .. "src/stc/scintilla/*")

includedirs(path .. "include/")
includedirs(path .. "src/common/")
includedirs(path .. "src/stc/scintilla/src/")
includedirs(path .. "src/stc/scintilla/lexlib/")
includedirs(path .. "src/stc/scintilla/lexers/")
includedirs(path .. "src/stc/scintilla/include/")
includedirs(path .. "lib/wx/include/gtk3-unicode-static-3.1/")

print(wxvars)

addSources("STC_SRC")

incDep("harfbuzz")
incDep("freetype")

if (gtk_linux) then
	includeBaseGtk()
end

includedirs("gdk/include")

-- aurorawxwidgets
setup("AuroraWxWidgets", "StaticLib")
defines({"__WX__", "WXBUILDING", "wxUSE_GUI=1", "wxUSE_BASE=1", platform_macro, "_FILE_OFFSET_BITS=64"})

links "AuroraWxRegex"
links "AuroraScintilla"

includedirs(path .. "include/")
includedirs(path .. "src/common/")
includedirs(path .. "src/regex/")
includedirs(path .. "src/stc/scintilla/include/")
includedirs(path .. "lib/wx/include/gtk3-unicode-static-3.1/")

incDep("harfbuzz")
incDep("ZLib")
incDep("libpng")
incDep("freetype")

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
	-- TODO: opengl sdk. i think it's included in modern winsdks, not sure
end


addSources("XML_SRC")
addSources("CORE_SRC")
addSources("BASE_SRC")
addSources("BASE_AND_GUI_SRC")
addSources("BASE_PLATFORM_SRC")
addSources("NET_PLATFORM_SRC")
addSources("NET_SRC")
addSources("OPENGL_SRC")
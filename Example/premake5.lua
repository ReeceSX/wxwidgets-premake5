-------------------------------------------------------
-- globals
-------------------------------------------------------
_G._projects = {}
_G.linux = os.get() == "linux"
_G.win32 = os.get() == "windows"

function includeProject(name)
    includedirs(_G._projects[name].inc)
    links(name)
end
_G.includeProject = includeProject

-------------------------------------------------------
-- create workspace 
-------------------------------------------------------

workspace "WxExample Premake5"
    configurations { "Debug", "Release" }

    location "Build_CompilerWorkingDirectory"

    symbols "On"
    staticruntime "On"

    filter "configurations:Debug"
        targetdir "Build_CompilerWorkingDirectory/bin/debug"
        defines { "DEBUG" }

    filter "configurations:Release"
        targetdir "Build_CompilerWorkingDirectory/bin/release"
        defines { "NDEBUG" }
        optimize "Size"

    filter {}

    flags { "NoIncrementalLink" }
    editandcontinue "Off"

    if (not _G.win32) then
        toolset "clang"

        buildoptions {"-fms-extensions"}

		disablewarnings {
			-- we live life on the edge
			"unused-result",
			-- warning: unused unused enumeration
			"unused-value",
			-- idk what this is but its annoying me
			"unknown-warning-option"
		}
    end

    ---------------------------------------------------
    -- TODO: ADD YOUR OWN PREPROCESSOR DEFINTIONS 
    -- THE FOLLOWING TRASH IS JUST AN EXAMPLE
    ---------------------------------------------------
    if (_G.win32) then
        defines "AURORA_PLATFORM_WIN32"
    elseif (_G.linux) then
        defines "AURORA_PLATFORM_LINUX"
    end

    defines "AURORA_ARCH_X64"
    ---------------------------------------------------
-------------------------------------------------------
wxWidgets = require("wxwidgets-example")
-------------------------------------------------------
function includeOSRuntime()

    if (_G.linux) then
        links "pthread"
        links "gtk-3"
        links "gdk-3"
        links "atk-1.0"
        links "gio-2.0"
        links "pangoft2-1.0"
        links "gdk_pixbuf-2.0"
        links "pangocairo-1.0" 
        links "cairo" 
        links "pango-1.0" 
        links "fontconfig"
        links "gobject-2.0"
        links "gmodule-2.0"
        links "gthread-2.0"
        links "glib-2.0"
        links "X11"
        links "dl"
        links "Xxf86vm"
        links "Xext"
        links "Xt"
        links "SM"
    elseif (_G.win32) then
        links "Comctl32.lib"
        links "Rpcrt4.lib"
        links "Shlwapi.lib"
    end
end

function includeWxWidgets()
    includedirs "wxWidgets/include/"
    includedirs "wxWidgets/src/common/"

    includedirs "wxConfig/"

    links "AuroraWxRegex"
    links "AuroraScintilla"
    links "AuroraWxWidgets"

    defines (wxWidgets.wxGlobals)

    if (wxWidgets.linux) then
        wxWidgets.includeBaseGtk()
    end 
end

-------------------------------------------------------
boilerplateProject = require("boilerplateProject")
-------------------------------------------------------

boilerplateProject("AuroraZLib", "StaticLib", "Vendor/Compression/ZLib", "Vendor/Compression/ZLib")
excludes "Vendor/Compression/ZLib/contrib/**.*"
excludes "Vendor/Compression/ZLib/examples/**.*"
excludes "Vendor/Compression/ZLib/test/**.*"

boilerplateProject( "AuroraPng",
                    "StaticLib",
                    "Vendor/Media/libpng",
                    "Vendor/Media/libpng")

excludes "Vendor/Media/libpng/mips/**.c"
excludes "Vendor/Media/libpng/intel/**.c"
excludes "Vendor/Media/libpng/powerpc/**.c"
excludes "Vendor/Media/libpng/arm/**.c"
files "Vendor/Media/libpng/intel/**.c"
defines "PNG_INTEL_SSE_OPT=1"
includeProject("AuroraZLib")


boilerplateProject( "AuroraFreetype",
                    "StaticLib",
                    "Vendor/Graphics/freetype/src",
                    "Vendor/Graphics/freetype/include")
defines "USE_HARFBUZZ=0"
defines "FT_CONFIG_OPTION_SYSTEM_ZLIB=1"
defines "FT2_BUILD_LIBRARY=1"

-- Not required portable/tools
excludes "Vendor/Graphics/freetype/src/lzw/**.c"
excludes "Vendor/Graphics/freetype/src/gzip/**.c"
excludes "Vendor/Graphics/freetype/src/tools/**.c"
excludes "Vendor/Graphics/freetype/src/gxvalid/**.c"

-- Single C files. Why? Single C file optimizer? Bad build chain? 
-- Either way, we want the real file in our solution for debugging
excludes "Vendor/Graphics/freetype/src/autofit/autofit.c"
excludes "Vendor/Graphics/freetype/src/base/ftbase.c"
excludes "Vendor/Graphics/freetype/src/bdf/bdf.c"
excludes "Vendor/Graphics/freetype/src/bzip2/bzip2.c"
excludes "Vendor/Graphics/freetype/src/cache/ftcache.c"
excludes "Vendor/Graphics/freetype/src/cff/cff.c"
excludes "Vendor/Graphics/freetype/src/cid/cidriver.c"
excludes "Vendor/Graphics/freetype/src/truetype/truetype.c"
excludes "Vendor/Graphics/freetype/src/smooth/smooth.c"
excludes "Vendor/Graphics/freetype/src/sfnt/sfnt.c"
excludes "Vendor/Graphics/freetype/src/raster/raster.c"
excludes "Vendor/Graphics/freetype/src/psnames/psnames.c"
excludes "Vendor/Graphics/freetype/src/pshinter/pshinter.c"
excludes "Vendor/Graphics/freetype/src/psaux/psaux.c"
excludes "Vendor/Graphics/freetype/src/pfr/pfr.c"
excludes "Vendor/Graphics/freetype/src/pcf/pcf.c"
excludes "Vendor/Graphics/freetype/src/otv/otv.c"
excludes "Vendor/Graphics/freetype/src/otvalid/otvalid.c"
excludes "Vendor/Graphics/freetype/src/type1/type1.c"
excludes "Vendor/Graphics/freetype/src/type42/type42.c"
excludes "Vendor/Graphics/freetype/src/winfonts/winfonts.c"

includeProject("AuroraZLib")

boilerplateProject( "AuroraHarfbuzz",
                    "StaticLib",
                    "Vendor/Graphics/harfbuzz/src",
                    "Vendor/Graphics/harfbuzz/src")

excludes "Vendor/Graphics/harfbuzz/src/test-*.*"
excludes "Vendor/Graphics/harfbuzz/src/dump-*.*"
excludes "Vendor/Graphics/harfbuzz/src/failing-*.*"
excludes "Vendor/Graphics/harfbuzz/src/hb-glib.cc"
excludes "Vendor/Graphics/harfbuzz/src/hb-gdi.cc"
excludes "Vendor/Graphics/harfbuzz/src/main.cc"
excludes "Vendor/Graphics/harfbuzz/src/test.cc"
excludes "Vendor/Graphics/harfbuzz/src/hb-gobject-structs.cc"
excludes "Vendor/Graphics/harfbuzz/src/harfbuzz.cc" -- single cxx file :(

defines "HAVE_FREETYPE=1"
includeProject("AuroraFreetype")
includeProject("AuroraZLib")
includeProject("AuroraPng")

-------------------------------------------------------
wxWidgets.setupWxWidgets()
-------------------------------------------------------

boilerplateProject("WxClockSample", "WindowedApp", "WxClockSample/Source")
includeWxWidgets()
includeProject("AuroraHarfbuzz")
includeProject("AuroraFreetype")
includeProject("AuroraPng")
includeProject("AuroraZLib")

includeOSRuntime()

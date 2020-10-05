-------------------------------------------------------
-- globals
-------------------------------------------------------
_G._projects = {}

function includeProject(name)
    print("including", name)
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

    if (not isWin) then
        toolset "clang"

        buildoptions {"-fms-extensions"}
    end

    disablewarnings {
        -- we live life on the edge
        "unused-result",
        -- warning: unused unused enumeration
        "unused-value",
        -- idk what this is but its annoying me
        "unknown-warning-option"

    }


-------------------------------------------------------
function includeOSRuntime()
    if (true) then
---------------------------
--        -- weird elf quirk
--        -- some cairo/x11/whatever ELF module will have an an UNDEF symbol referencing png/libz 
--        -- ld will find said file in the system libraries folder[s] and then cock-block the symbol name.
--        --  we need to include our cake first for us to link 
--        --  **OUR** references to **OUR** static library. 
--        -- we'll strip symbols so hopefully we dont mess with the ABI of other external libs 
--        --  such is the only way i could think of this being an issue
--        includeProject("AuroraPng")
--        includeProject("AuroraZLib")

        -- ignore everything above here if you are not compile zlib/png
        links "png"
        links "z"
-------------------------------
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
        -- DX Compiler etc
    end
end

function includeWxWidgets()
    includedirs "wxWidgets/include"
    includedirs "wxWidgets/src/common/"

    includedirs "wxConfig"

    links "AuroraWxRegex"
    links "AuroraScintilla"
    links "AuroraWxWidgets"

    defines (_G.wxGlobals)

    if (_G.linux) then
        _G.includeBaseGtk()

    end 
end


function includePipelineDeps()
    includeOSRuntime()
    --includeExtendedRuntime()
    --includeDX(true)
    --includeCompression()
    --includeGraphicsCommon()
    --includePipelineMedia()
    includeWxWidgets()
end 

-------------------------------------------------------

require("wxwidgets-example")

-------------------------------------------------------
boilerplateProject = require("boilerplateProject")

boilerplateProject("WxClockSample", "ConsoleApp", "WxClockSample/Source")
includePipelineDeps()
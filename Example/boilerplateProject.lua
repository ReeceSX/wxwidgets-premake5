 
-- REDACTED AURORA FILE
--local defintions = require("preprocessors")
--local projectCopyCmds = require("buildPostProcess")

local boilerplateProject = function(name, type, src, inc, dest) 
    print("project", name)
    project(name)

    targetname(name)
    language("C++")
    cppdialect("C++17")
    kind(type)

    if (not _G.win32) then
    if (type == "SharedLib") then
        pic "On"
    end
    end 

    if (_G.win32) then
        characterset("MBCS")
        staticruntime("Off")
    end

    location("Build_CompilerWorkingDirectory/" .. name .. "/")

    defines
    {
        "_ITERATOR_DEBUG_LEVEL=0",
    }

    --defines(defintions)

    if inc ~= nil then
        print("", "include", inc)
        includedirs
        {
            "Include",
            inc
        }
    else
        includedirs
        {
            "Include"
        }
    end

    if src ~= nil then
        print("", "source", src)
        files
        {
            src .. "/**.*pp",
            src .. "/**.c",
            src .. "/**.cc",
            src .. "/**.h",
            src .. "/**.masm"
        }
    end

    --if projectCopyCmds ~= true then
    --if dest ~= nil then
    --    print("destination", dest)
    --    projectCopyCmds(name, type, dest)
    --end
    --end

    _G._projects[name] = {path = src, inc = inc};

    print()
end

return boilerplateProject
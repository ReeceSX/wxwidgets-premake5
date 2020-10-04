-- ./configure --with-gtk=3 --with-libjpeg=no  --with-libtiff=no --enable-stl --with-expat=no --with-liblzma=no --enable-utf8 --enable-protocols=no --enable-ipc=no --with-libnotify=no --without-gtkprint --with-opengl --with-xtest=no --with-cxx=17 --disable-shared
-- partially converted from Makefile and autoconfs configure bash script manually

local setup = require("boilerplateProject")

------------------------------------------------------------------------

local gl = true
local path = "Vendor/Graphics/wxWidgets/"
local gtk_linux = _G.linux  
local windows = _G.win32
local incDep = _G.includeProject

local platform_macro = "whatFuckingBullshit"

if (windows) then
	platform_macro = "__WXMSW__"
elseif (gtk_linux) then
	platform_macro = "__WXGTK__"
end

----------------------------------------------------------------------------
-- mostly autogened, copy/pasted, and multi-line edited 
-- i wouldn't manually update this in the future, and neither should you >:D 
----------------------------------------------------------------------------

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
files(path .. "src/stc/*")
excludes(path .. "src/stc/PlatWXcocoa.mm")
excludes(path .. "src/stc/stc_i18n.cpp")

includedirs(path .. "include/")
includedirs(path .. "src/common/")
includedirs(path .. "src/stc/scintilla/src/")
includedirs(path .. "src/stc/scintilla/lexlib/")
includedirs(path .. "src/stc/scintilla/lexers/")
includedirs(path .. "src/stc/scintilla/include/")
includedirs(path .. "lib/wx/include/gtk3-unicode-static-3.1/")

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

if (gtk_linux) then
	files(path .. "src/common/fdiodispatcher.cpp")
	files(path .. "src/common/selectdispatcher.cpp")
	files(path .. "src/common/socketiohandler.cpp" )
	files(path .. "src/unix/appunix.cpp")
	files(path .. "src/unix/dir.cpp")
	files(path .. "src/unix/dlunix.cpp")
	files(path .. "src/unix/epolldispatcher.cpp")
	files(path .. "src/unix/evtloopunix.cpp")
	files(path .. "src/unix/fdiounix.cpp")
	files(path .. "src/unix/snglinst.cpp")
	files(path .. "src/unix/stackwalk.cpp")
	files(path .. "src/unix/timerunx.cpp")
	files(path .. "src/unix/threadpsx.cpp")
	files(path .. "src/unix/utilsunx.cpp")
	files(path .. "src/unix/wakeuppipe.cpp")
	files(path .. "src/unix/fswatcher_kqueue.cpp"	)
	files(path .. "src/unix/mimetype.cpp")
	files(path .. "src/unix/fswatcher_inotify.cpp"	)
	files(path .. "src/unix/stdpaths.cpp")
	files(path .. "src/unix/secretstore.cpp"	)
	files(path .. "src/unix/sockunix.cpp")

	files(path .. "src/gtk/*")
	excludes(path .. "src/gtk/webview_webkit.cpp")
	excludes(path .. "src/gtk/webview_webkit2_extension.cpp")
	excludes(path .. "src/gtk/webview_webkit2.cpp")
	excludes(path .. "src/gtk/glcanvas.cpp")
	excludes(path .. "src/gtk/dc.cpp")
	excludes(path .. "src/gtk/dcclient.cpp")
	excludes(path .. "src/gtk/dcmemory.cpp")
	excludes(path .. "src/gtk/dcscreen.cpp")
	excludes(path .. "src/gtk/eggtrayicon.c")

elseif (windows) then 
	files(path .. "src/msw/*")
	excludes(path .. "src/msw/webview_ie.cpp")
	excludes(path .. "src/msw/webview_edge.cpp")
	excludes(path .. "src/msw/glcanvas.cpp")
end 

if (gl) then
	files(path .. "src/common/glcmn.cpp")
	if (gtk_linux) then
		files(path .. "src/unix/glegl.cpp")
		files(path .. "src/unix/glx11.cpp")
		utilsx11
		files(path .. "src/gtk/glcanvas.cpp")
	elseif (windows) then 
		files(path .. "src/msw/glcanvas.cpp")
	end
end
local commonFiles=
{
	path .. "src/common/extended.c",
	path .. "src/common/any.cpp",
	path .. "src/common/appbase.cpp",
	path .. "src/common/arcall.cpp",
	path .. "src/common/arcfind.cpp",
	path .. "src/common/archive.cpp",
	path .. "src/common/arrstr.cpp",
	path .. "src/common/base64.cpp",
	path .. "src/common/clntdata.cpp",
	path .. "src/common/cmdline.cpp",
	path .. "src/common/config.cpp",
	path .. "src/common/convauto.cpp",
	path .. "src/common/datetime.cpp",
	path .. "src/common/datetimefmt.cpp",
	path .. "src/common/datstrm.cpp",
	path .. "src/common/dircmn.cpp",
	path .. "src/common/dynlib.cpp",
	path .. "src/common/dynload.cpp",
	path .. "src/common/encconv.cpp",
	path .. "src/common/evtloopcmn.cpp",
	path .. "src/common/ffile.cpp",
	path .. "src/common/file.cpp",
	path .. "src/common/fileback.cpp",
	path .. "src/common/fileconf.cpp",
	path .. "src/common/filefn.cpp",
	path .. "src/common/filename.cpp",
	path .. "src/common/filesys.cpp",
	path .. "src/common/filtall.cpp",
	path .. "src/common/filtfind.cpp",
	path .. "src/common/fmapbase.cpp",
	path .. "src/common/fs_arc.cpp",
	path .. "src/common/fs_filter.cpp",
	path .. "src/common/hash.cpp",
	path .. "src/common/hashmap.cpp",
	path .. "src/common/init.cpp",
	path .. "src/common/intl.cpp",
	path .. "src/common/ipcbase.cpp",
	path .. "src/common/languageinfo.cpp",
	path .. "src/common/list.cpp",
	path .. "src/common/log.cpp",
	path .. "src/common/longlong.cpp",
	path .. "src/common/memory.cpp",
	path .. "src/common/mimecmn.cpp",
	path .. "src/common/module.cpp",
	path .. "src/common/mstream.cpp",
	path .. "src/common/numformatter.cpp",
	path .. "src/common/object.cpp",
	path .. "src/common/platinfo.cpp",
	path .. "src/common/powercmn.cpp",
	path .. "src/common/process.cpp",
	path .. "src/common/regex.cpp",
	path .. "src/common/stdpbase.cpp",
	path .. "src/common/sstream.cpp",
	path .. "src/common/stdstream.cpp",
	path .. "src/common/stopwatch.cpp",
	path .. "src/common/strconv.cpp",
	path .. "src/common/stream.cpp",
	path .. "src/common/string.cpp",
	path .. "src/common/stringimpl.cpp",
	path .. "src/common/stringops.cpp",
	path .. "src/common/strvararg.cpp",
	path .. "src/common/sysopt.cpp",
	path .. "src/common/tarstrm.cpp",
	path .. "src/common/textbuf.cpp",
	path .. "src/common/textfile.cpp",
	path .. "src/common/threadinfo.cpp",
	path .. "src/common/time.cpp",
	path .. "src/common/timercmn.cpp",
	path .. "src/common/timerimpl.cpp",
	path .. "src/common/tokenzr.cpp",
	path .. "src/common/translation.cpp",
	path .. "src/common/txtstrm.cpp",
	path .. "src/common/unichar.cpp",
	path .. "src/common/uri.cpp",
	path .. "src/common/ustring.cpp",
	path .. "src/common/variant.cpp",
	path .. "src/common/wfstream.cpp",
	path .. "src/common/wxcrt.cpp",
	path .. "src/common/wxprintf.cpp",
	path .. "src/common/xlocale.cpp",
	path .. "src/common/xti.cpp",
	path .. "src/common/xtistrm.cpp",
	path .. "src/common/zipstrm.cpp",
	path .. "src/common/zstream.cpp",
	path .. "src/common/fswatchercmn.cpp",
	path .. "src/generic/fswatcherg.cpp",
	path .. "src/unix/secretstore.cpp",
	path .. "src/common/lzmastream.cpp",
	path .. "src/common/event.cpp",
	path .. "src/common/fs_mem.cpp",
	path .. "src/common/msgout.cpp",
	path .. "src/common/utilscmn.cpp"
}
files(commonFiles)

-- xml
local libXml = {path .. "src/xml/xml.cpp", path .. "src/common/xtixml.cpp"} 
files(libXml)

-- network
local libNet = {
	path .. "src/common/fs_inet.cpp", 
	path .. "src/common/ftp.cpp",
	path .. "src/common/http.cpp", 
	path .. "src/common/protocol.cpp",
	path .. "src/common/sckaddr.cpp", 
	path .. "src/common/sckfile.cpp",
	path .. "src/common/sckipc.cpp",
	path .. "src/common/sckstrm.cpp",
	path .. "src/common/socket.cpp",
	path .. "src/common/url.cpp"}
files(libNet)
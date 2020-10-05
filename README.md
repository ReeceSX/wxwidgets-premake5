
# Premake wxWidgets
Boilerplate scripts to build wxWidgets using premake given a preexisting build workspace  

## File structure 
| File |  Description|
|--|--|
| ./wxwidgets-boilerplate.lua | Example file containing the necessary premake calls to include wxWidgets into an existing workspace |
| ./wxwidgets-linux-gtk.lua | Build variables for targeting Linux with a gtk/x11 backend |
| ./wxwidgets-windows-msw.lua | Build variables for targeting windows (dwm) with a gdi backend |
|  |  |
| ./Example/ |  An example project - compiles on Linux and Windows|
|  |  |

## Compiling the example
### Linux 
Dependencies: libpng, harfbuzz, freetype2, zlib, gtk-3-0, X-11, glib, (dependencies of gtk - dgk, cairo, pango, fontconfig et al), pthread, gnome atk 
```
premake5 gmake2
cd Build_CompilerWorkingDirectory/
make -j<threads no>
```

Executable: Build_CompilerWorkingDirectory/bin/WxClockSample
### Windows
Dependencies: libpng, libz, harfbuzz (soft-depends freetype2), freetype2 (no deps) 
```
premake5 vs2019
devenv (or open in vs gui) Build_CompilerWorkingDirectory/<tbd>.sln
build solution
```


* note: external package managers are required for c libraries, including but not limited to libpng and libz, not including gtk on windows targets. Builds without issue on typical unix development machines with graphical libraries (x11, libz, gtk, harfbuzz, pango, cairo, et al), and builds on windows with some minor changes for linkage and include directories to account for Microsoft vcpkg/internal package managment systems*

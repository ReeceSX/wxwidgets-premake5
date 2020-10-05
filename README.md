
# Premake wxWidgets
Boilerplate scripts to build wxWidgets using premake given a preexisting build workspace  

## Compiling the example
### Linux 
Dependencies: libpng, harfbuzz, freetype2, zlib, gtk-3-0, X-11, glib, (dependencies of gtk - dgk, cairo, pango, fontconfig et al), pthread, gnome atk 
```
git submodule update --init --recursive
premake5 gmake2
cd Build_CompilerWorkingDirectory/
make -j<threads no>
```

Executable: Build_CompilerWorkingDirectory/bin/WxClockSample
### Windows
Dependencies (build scripts included): libpng, libz, harfbuzz (soft-depends freetype2), freetype2 (no deps)  
```
git submodule update --init --recursive
premake5 vs2019
devenv (or open in vs gui) Build_CompilerWorkingDirectory/<tbd>.sln
build solution
```

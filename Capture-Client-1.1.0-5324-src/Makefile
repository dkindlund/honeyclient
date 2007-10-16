##############################################################################
##
##  Capture-HPC
##


## Change these paths to the correct paths on your system
BOOSTINC = F:\Boost
BOOSTLIB = F:\Boost\libs;F:\Boost\libs\regex\build\vc80
PLATFORMSDKINC = F:\Program Files\Microsoft Platform SDK\Include
PLATFORMSDKLIB = F:\Program Files\Microsoft Platform SDK\Lib
WDKINC = F:\WinDDK\6000\inc\api
WDKLIB = F:\WinDDK\6000\lib\wxp\i386

BIND = $(MAKEDIR)\bin


INCLUDE = $(INCLUDE);$(BOOSTINC);$(PLATFORMSDKINC);$(WDKINC);
LIB = $(LIB);$(BOOSTLIB);$(PLATFORMSDKLIB);$(WDKLIB)

all: dirs \
	KernelDriver \
	Capture \

dirs:
#	if not exist $(BIND) mkdir $(BIND)

KernelDriver :


Capture :
	@vcbuild Capture.vcproj Release /u
	cd "$(MAKEDIR)"
	cd "KernelDriver"
	@$(MAKE) /NOLOGO /$(MAKEFLAGS)
	cd "$(MAKEDIR)"

install :
	cd "$(MAKEDIR)\KernelDriver"
	@$(MAKE) /NOLOGO /$(MAKEFLAGS) install
	cd "$(MAKEDIR)"
	copy "Readme.txt" $(BIND)
	copy "COPYING" $(BIND)
	copy "Capture.bat" $(BIND)
	cd "release"
	copy "Capture.exe" $(BIND)
	cd "$(MAKEDIR)"
	cd "ExclusionLists"
	copy *.exl $(BIND)
	cd "$(MAKEDIR)"
	copy *.inf $(BIND)
	cd "$(MAKEDIR)"
	cd "Config"
	copy *.conf $(BIND)
	cd "$(MAKEDIR)"
	cd "ext_lib"
	copy *.* $(BIND)
	cd "$(MAKEDIR)"


clean:
	cd "$(MAKEDIR)\KernelDriver"
	@$(MAKE) /NOLOGO /$(MAKEFLAGS) clean
	cd "$(MAKEDIR)"
	@vcbuild Capture.vcproj /c Release
	-del /Q /S $(BIND) 2>nul
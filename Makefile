PREFIX := /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
CC := $(PREFIX)/clang
LD := $(HOME)/ld64/linker/ld64-objc1
SDK := $(THEOS)/sdks/iPhoneOS1.1.5.sdk

SRC := Tweak.m $(wildcard Firmware/*.m)
OUT := FullIconList.dylib

PXL_WORKINGDIR := _temp
PXL_INSTROOT := $(PXL_WORKINGDIR)/instroot

STRICT_FLAGS := -Wall -Werror -Wpedantic -Wextra -Wshadow -Wformat=2 -Wnull-dereference -Wno-cast-function-type-mismatch -Wno-nullability-extension -Wno-dollar-in-identifier-extension -Wno-variadic-macros

CFLAGS := -arch armv6 -isysroot $(SDK) $(STRICT_FLAGS) -mthumb -miphoneos-version-min=1.0 -D_FORTIFY_SOURCE=0 -mfpu=none -I$(THEOS)/vendor/lib/CydiaSubstrate.framework/Headers --ld-path=$(LD)
LDFLAGS := -Wl,-install_name,/Library/MicroInjector/DynamicLibraries/$(OUT) -dynamiclib ../MicroInjector/libmicroinjector.dylib -fobjc-runtime=macosx-fragile -lobjc -framework Foundation -framework CoreFoundation

.PHONY: all clean

$(OUT): $(SRC)
	$(CC) $(SRC) $(CFLAGS) $(LDFLAGS) -o $(OUT)
	strip -x $(OUT)

all: $(OUT)

$(PXL_INSTROOT):
	mkdir -p $(PXL_INSTROOT)/Library/MicroInjector/DynamicLibraries

pxl: all $(PXL_INSTROOT)
	@echo "[+] Creating PXL package"

	cp $(OUT) $(PXL_INSTROOT)/Library/MicroInjector/DynamicLibraries/FullIconList.dylib
	cp FullIconList.plist $(PXL_INSTROOT)/Library/MicroInjector/DynamicLibraries/FullIconList.plist
	cp PxlPkg.plist $(PXL_WORKINGDIR)/PxlPkg.plist
	cd $(PXL_WORKINGDIR) && zip -r ../FullIconList.pxl .
	rm -rf $(PXL_WORKINGDIR)

	@echo "[+] Done!"

clean:
	rm -f $(OUT) FullIconList.pxl
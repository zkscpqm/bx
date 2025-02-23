#
# Copyright 2011-2021 Branimir Karadzic. All rights reserved.
# License: https://github.com/bkaradzic/bx#license-bsd-2-clause
#

SILENT ?= @
CURR_OS := $(shell uname 2>/dev/null || echo Windows)

ifneq (,$(findstring MSYS,$(CURR_OS)))
    CURR_OS := Windows
endif

ifeq ($(CURR_OS),Windows)
	OS = windows
	SHELL := cmd.exe
	RM := rmdir /s /q

    GENIE := ..\bx\tools\bin\windows\genie.exe
    BIN2C := ..\bx\tools\bin\windows\bin2c.exe
    NINJA := ..\bx\tools\bin\windows\ninja.exe

    BUILD_PROJECT_DIR=gmake-mingw-gcc
    BUILD_OUTPUT_DIR=win32_mingw-gcc
    BUILD_TOOLS_CONFIG=release64

    EXE=.exe
    export MINGW := C:/msys64/mingw64

else ifeq ($(CURR_OS),Darwin)
	OS = darwin
	SHELL := /bin/bash
	RM := rm -rf

    GENIE := ../bx/tools/bin/darwin/genie
    BIN2C := ../bx/tools/bin/darwin/bin2c
    NINJA := ../bx/tools/bin/darwin/ninja

    BUILD_PROJECT_DIR=gmake-osx-x64
    BUILD_OUTPUT_DIR=osx-x64
    BUILD_TOOLS_CONFIG=release

    EXE=

else ifeq ($(CURR_OS),Linux)
	OS = linux
	SHELL := /bin/bash
	RM := rm -rf

    GENIE := ../bx/tools/bin/linux/genie
    BIN2C := ../bx/tools/bin/linux/bin2c
    NINJA := ../bx/tools/bin/linux/ninja

    BUILD_PROJECT_DIR=gmake-linux
    BUILD_OUTPUT_DIR=linux64_gcc
    BUILD_TOOLS_CONFIG=release64

    EXE=

endif

all:
	$(GENIE)                       vs2017
	$(GENIE)                       vs2019
	$(GENIE) --gcc=android-arm     gmake
	$(GENIE) --gcc=android-arm64   gmake
	$(GENIE) --gcc=android-x86     gmake
	$(GENIE) --gcc=mingw-gcc       gmake
	$(GENIE) --gcc=linux-gcc       gmake
	$(GENIE) --gcc=haiku           gmake
	$(GENIE) --gcc=osx-x64         gmake
	$(GENIE) --gcc=osx-arm64       gmake
	$(GENIE) --gcc=ios-arm         gmake
	$(GENIE) --gcc=ios-simulator   gmake
	$(GENIE) --gcc=ios-simulator64 gmake
	$(GENIE)                       xcode8

.build/projects/gmake-android-arm:
	$(GENIE) --gcc=android-arm gmake
android-arm-debug: .build/projects/gmake-android-arm
	make -R -C .build/projects/gmake-android-arm config=debug
android-arm-release: .build/projects/gmake-android-arm
	make -R -C .build/projects/gmake-android-arm config=release
android-arm: android-arm-debug android-arm-release

.build/projects/gmake-android-arm64:
	$(GENIE) --gcc=android-arm64 gmake
android-arm64-debug: .build/projects/gmake-android-arm64
	make -R -C .build/projects/gmake-android-arm64 config=debug
android-arm64-release: .build/projects/gmake-android-arm64
	make -R -C .build/projects/gmake-android-arm64 config=release
android-arm64: android-arm64-debug android-arm64-release

.build/projects/gmake-android-x86:
	$(GENIE) --gcc=android-x86 gmake
android-x86-debug: .build/projects/gmake-android-x86
	make -R -C .build/projects/gmake-android-x86 config=debug
android-x86-release: .build/projects/gmake-android-x86
	make -R -C .build/projects/gmake-android-x86 config=release
android-x86: android-x86-debug android-x86-release

.build/projects/gmake-linux:
	$(GENIE) --gcc=linux-gcc gmake
linux-debug64: .build/projects/gmake-linux
	make -R -C .build/projects/gmake-linux config=debug64
linux-release64: .build/projects/gmake-linux
	make -R -C .build/projects/gmake-linux config=release64
linux: linux-debug64 linux-release64

.build/projects/gmake-haiku:
	$(GENIE) --gcc=haiku gmake
haiku-debug64: .build/projects/gmake-haiku
	make -R -C .build/projects/gmake-haiku config=debug64
haiku-release64: .build/projects/gmake-haiku
	make -R -C .build/projects/gmake-haiku config=release64
haiku: haiku-debug64 haiku-release64

.build/projects/gmake-mingw-gcc:
	$(GENIE) --gcc=mingw-gcc gmake
mingw-gcc-debug32: .build/projects/gmake-mingw-gcc
	make -R -C .build/projects/gmake-mingw-gcc config=debug32
mingw-gcc-release32: .build/projects/gmake-mingw-gcc
	make -R -C .build/projects/gmake-mingw-gcc config=release32
mingw-gcc-debug64: .build/projects/gmake-mingw-gcc
	make -R -C .build/projects/gmake-mingw-gcc config=debug64
mingw-gcc-release64: .build/projects/gmake-mingw-gcc
	make -R -C .build/projects/gmake-mingw-gcc config=release64
mingw-gcc: mingw-gcc-debug32 mingw-gcc-release32 mingw-gcc-debug64 mingw-gcc-release64
mingw-gcc-64: mingw-gcc-debug64 mingw-gcc-release64

.build/projects/gmake-mingw-clang:
	$(GENIE) --clang=mingw-clang gmake
mingw-clang-debug32: .build/projects/gmake-mingw-clang
	make -R -C .build/projects/gmake-mingw-clang config=debug32
mingw-clang-release32: .build/projects/gmake-mingw-clang
	make -R -C .build/projects/gmake-mingw-clang config=release32
mingw-clang-debug64: .build/projects/gmake-mingw-clang
	make -R -C .build/projects/gmake-mingw-clang config=debug64
mingw-clang-release64: .build/projects/gmake-mingw-clang
	make -R -C .build/projects/gmake-mingw-clang config=release64
mingw-clang: mingw-clang-debug32 mingw-clang-release32 mingw-clang-debug64 mingw-clang-release64

.build/projects/vs2017:
	$(GENIE) vs2017

.build/projects/gmake-osx-x64:
	$(GENIE) --gcc=osx-x64 gmake
osx-x64-debug: .build/projects/gmake-osx-x64
	make -C .build/projects/gmake-osx config=debug
osx-x64-release: .build/projects/gmake-osx-x64
	make -C .build/projects/gmake-osx config=release
osx-x64: osx-x64-debug osx-x64-release

.build/projects/gmake-ios-arm:
	$(GENIE) --gcc=ios-arm gmake
ios-arm-debug: .build/projects/gmake-ios-arm
	make -R -C .build/projects/gmake-ios-arm config=debug
ios-arm-release: .build/projects/gmake-ios-arm
	make -R -C .build/projects/gmake-ios-arm config=release
ios-arm: ios-arm-debug ios-arm-release

.build/projects/gmake-ios-simulator:
	$(GENIE) --gcc=ios-simulator gmake
ios-simulator-debug: .build/projects/gmake-ios-simulator
	make -R -C .build/projects/gmake-ios-simulator config=debug
ios-simulator-release: .build/projects/gmake-ios-simulator
	make -R -C .build/projects/gmake-ios-simulator config=release
ios-simulator: ios-simulator-debug ios-simulator-release

.build/projects/gmake-ios-simulator64:
	$(GENIE) --gcc=ios-simulator64 gmake
ios-simulator64-debug: .build/projects/gmake-ios-simulator64
	make -R -C .build/projects/gmake-ios-simulator64 config=debug
ios-simulator64-release: .build/projects/gmake-ios-simulator64
	make -R -C .build/projects/gmake-ios-simulator64 config=release
ios-simulator64: ios-simulator64-debug ios-simulator64-release

rebuild-shaders:
	make -R -C examples rebuild

analyze:
	cppcheck$(EXE) src/ --force --inconclusive --check-level=exhaustive

docs:
	doxygen scripts/bgfx.doxygen
	markdown README.md > .build/docs/readme.html

clean:
	@echo Cleaning...
	@$(RM) .build
	@mkdir .build

# bin2c
.build/osx-x64/bin/bin2cRelease: .build/projects/gmake-osx-x64
	$(SILENT) make -C .build/projects/gmake-osx-x64 bin2c config=$(BUILD_TOOLS_CONFIG)

tools/bin/darwin/bin2c: .build/osx-x64/bin/bin2cRelease
	$(SILENT) cp $(<) $(@)

.build/linux64_gcc/bin/bin2cRelease: .build/projects/gmake-linux
	$(SILENT) make -C .build/projects/gmake-linux bin2c config=$(BUILD_TOOLS_CONFIG)

tools/bin/linux/bin2c: .build/linux64_gcc/bin/bin2cRelease
	$(SILENT) cp $(<) $(@)

.build/haiku64_gcc/bin/bin2cRelease: .build/projects/gmake-haiku
	$(SILENT) make -C .build/projects/gmake-haiku bin2c config=$(BUILD_TOOLS_CONFIG)

tools/bin/haiku/bin2c: .build/haiku64_gcc/bin/bin2cRelease
	$(SILENT) cp $(<) $(@)

.build/win64_mingw-gcc/bin/bin2cRelease.exe: .build/projects/gmake-mingw-gcc
	$(SILENT) make -C .build/projects/gmake-mingw-gcc bin2c config=$(BUILD_TOOLS_CONFIG)

tools/bin/windows/bin2c.exe: .build/win64_mingw-gcc/bin/bin2cRelease.exe
	$(SILENT) cp $(<) $(@)

# lemon
.build/osx-x64/bin/lemonRelease: .build/projects/gmake-osx-x64
	$(SILENT) make -C .build/projects/gmake-osx-x64 lemon config=$(BUILD_TOOLS_CONFIG)

tools/bin/darwin/lemon: .build/osx-x64/bin/lemonRelease
	$(SILENT) cp $(<) $(@)

.build/linux64_gcc/bin/lemonRelease: .build/projects/gmake-linux
	$(SILENT) make -C .build/projects/gmake-linux lemon config=$(BUILD_TOOLS_CONFIG)

tools/bin/linux/lemon: .build/linux64_gcc/bin/lemonRelease
	$(SILENT) cp $(<) $(@)

.build/haiku64_gcc/bin/lemonRelease: .build/projects/gmake-haiku
	$(SILENT) make -C .build/projects/gmake-haiku lemon config=$(BUILD_TOOLS_CONFIG)

tools/bin/haiku/lemon: .build/haiku64_gcc/bin/lemonRelease
	$(SILENT) cp $(<) $(@)

.build/win64_mingw-gcc/bin/lemonRelease.exe: .build/projects/gmake-mingw-gcc
	$(SILENT) make -C .build/projects/gmake-mingw-gcc lemon config=$(BUILD_TOOLS_CONFIG)

tools/bin/windows/lemon.exe: .build/win64_mingw-gcc/bin/lemonRelease.exe
	$(SILENT) cp $(<) $(@)

tools/bin/$(OS)/lempar.c: tools/lemon/lempar.c
	$(SILENT) cp $(<) $(@)

lemon: tools/bin/$(OS)/lemon$(EXE) tools/bin/$(OS)/lempar.c

tools: $(BIN2C) lemon

dist: tools/bin/darwin/bin2c tools/bin/linux/bin2c tools/bin/windows/bin2c.exe tools/bin/haiku/bin2c

.build/$(BUILD_OUTPUT_DIR)/bin/bx.testRelease$(EXE): .build/projects/$(BUILD_PROJECT_DIR)
	$(SILENT) make -C .build/projects/$(BUILD_PROJECT_DIR) bx.test config=$(BUILD_TOOLS_CONFIG)

test: .build/$(BUILD_OUTPUT_DIR)/bin/bx.testRelease$(EXE)
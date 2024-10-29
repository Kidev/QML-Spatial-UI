QT_ROOT ?= "/opt/Qt"
QT_VERSION ?= "6.6.3"
EMSDK_VERSION ?= "3.1.50"
QT_ARCH ?= "gcc_64
QT_HOST_ARCH ?= "gcc_64"
QT_TARGET_ARCH ?= "wasm_singlethread"

all: desktop run

desktop: clean
	@bash example/build.sh "$(QT_ROOT)" "$(QT_VERSION)" "$(QT_ARCH)"

web: clean
	@bash example/build-web.sh "$(QT_ROOT)" "$(QT_VERSION)" "$(EMSDK_VERSION)" "$(QT_HOST_ARCH)" "$(QT_TARGET_ARCH)"

run-web:
	emsdk/upstream/emscripten/emrun ./build/example/index.html --kill_start --kill_exit

run:
	./build/example/exampleExec

clean:
	@rm -rf build CMakeLists.txt.user

.PHONY: clean run run-web

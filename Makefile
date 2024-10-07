QT_ROOT ?= "/opt/Qt"
QT_VERSION ?= "6.7.3"
EMSDK_VERSION ?= "3.1.37"

all: desktop

desktop:
	@bash build.sh "$(QT_ROOT)" "$(QT_VERSION)"

web:
	@bash build-web.sh "$(QT_ROOT)" "$(QT_VERSION)" "$(EMSDK_VERSION)"

run-web:
	emsdk/upstream/emscripten/emrun ./build/example/index.html --kill_start --kill_exit

run:
	./build/example/exampleExec

clean:
	@rm -rf build CMakeLists.txt.user

.PHONY: clean run run-web

all: desktop

desktop:
	@bash build.sh

web:
	@bash build-web.sh

run-web:
	emsdk/upstream/emscripten/emrun ./build/example/index.html --kill_start --kill_exit

run:
	./build/example/exampleExec

clean:
	@rm -rf build CMakeLists.txt.user

.PHONY: clean run run-web

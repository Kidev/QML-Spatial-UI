all:
	@bash build.sh

web:
	@bash build-web.sh

run-web: web
	@killall -9 emrun &>/dev/null
	@emrun ./build/example/index.html

run: all
	killall -9 exampleExec &>/dev/null
	./build/example/exampleExec

clean:
	@rm -rf build CMakeLists.txt.user

.PHONY: clean run run-web

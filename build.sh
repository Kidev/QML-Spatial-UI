export QT_ROOT="${QT_ROOT:-/opt/Qt/6.7.2/gcc_64}"
mkdir -p build
cmake -S . -B build -DCMAKE_PREFIX_PATH=${QT_ROOT} -DBUILD_EXAMPLE=ON -DDEBUG=ON
cmake --build build/
killall -9 exampleExec &>/dev/null
./build/example/exampleExec

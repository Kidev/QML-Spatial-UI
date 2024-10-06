export QT_ROOT="${QT_ROOT:-/opt/Qt/6.6.0/wasm_multithread}"
export QT_HOST_PATH_ROOT="${QT_HOST_PATH_ROOT:-/opt/Qt/6.6.0/gcc_64}"

export QT_HOST_CMAKE_DIR="${QT_HOST_PATH_ROOT}/lib/cmake"
export QT_MODULE_PATH="${QT_ROOT}/lib/cmake/Qt6/"
export QT_TOOLCHAIN="${QT_ROOT}/lib/cmake/Qt6/qt.toolchain.cmake"

git clone https://github.com/emscripten-core/emsdk.git
./emsdk/emsdk install 3.1.37
./emsdk/emsdk activate 3.1.37

source ./emsdk/emsdk_env.sh

mkdir -p build
emcmake cmake -S . -B build -DQT_HOST_PATH=${QT_HOST_PATH_ROOT} -DQT_HOST_PATH_CMAKE_DIR=${QT_HOST_CMAKE_DIR} -DQt6_DIR=${QT_MODULE_PATH} -DCMAKE_TOOLCHAIN_FILE=${QT_TOOLCHAIN} -DCMAKE_PREFIX_PATH=${QT_ROOT} -DBUILD_EXAMPLE=ON -DEMSCRIPTEN=ON
cmake --build build/

cp example/img/favicon.ico build/example/favicon.ico -f
cp example/img/logo.png build/example/logo.png -f

mv build/example/exampleExec.html build/example/index.html

sed -i 's#<title>exampleExec</title>#<title>QML Spatial UI | Kidev<\/title><link rel="icon" src="favicon.ico" type="image/x-icon">#g' build/example/index.html
sed -i "s#<strong>Qt for WebAssembly: exampleExec</strong>#<strong style='color:\#ffffff'>Kidev's QML Spatial UI powered by Qt6</strong>#g" build/example/index.html
sed -i "s# height: 100% }# height: 100%; background-color:\#01010c;#g" build/example/index.html
sed -i 's#<img src="qtlogo.svg" width="320" height="200"#<img src="logo.png" width="320" height="320"#g' build/example/index.html

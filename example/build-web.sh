QT_ROOT=$1
QT_VERSION=$2
EMSDK_VERSION=$3

QT_VERSION_NAME="Qt${QT_VERSION:0:1}"
QT_ROOT_WASM="${QT_ROOT}/${QT_VERSION}/wasm_multithread"
QT_ROOT_GCC="${QT_ROOT}/${QT_VERSION}/gcc_64"
QT_HOST_CMAKE_DIR="${QT_ROOT_GCC}/lib/cmake"
QT_MODULE_PATH="${QT_ROOT_WASM}/lib/cmake/${QT_VERSION_NAME}"
QT_TOOLCHAIN="${QT_ROOT_WASM}/lib/cmake/${QT_VERSION_NAME}/qt.toolchain.cmake"

git clone https://github.com/emscripten-core/emsdk.git
./emsdk/emsdk install ${EMSDK_VERSION}
./emsdk/emsdk activate ${EMSDK_VERSION}

source ./emsdk/emsdk_env.sh

mkdir -p build
./emsdk/upstream/emscripten/emcmake cmake -G Ninja -S . -B build \
  -DQT_HOST_PATH=${QT_ROOT_GCC} \
  -DQT_HOST_PATH_CMAKE_DIR=${QT_HOST_CMAKE_DIR} \
  -DQt6_DIR=${QT_MODULE_PATH} \
  -DCMAKE_TOOLCHAIN_FILE=${QT_TOOLCHAIN} \
  -DCMAKE_PREFIX_PATH=${QT_ROOT} \
  -DEMSCRIPTEN=ON \
  -DBUILD_EXAMPLE=ON
cmake --build build/

cp example/img/favicon.ico build/example/favicon.ico -f
cp example/img/logo.png build/example/logo.png -f
cp example/img/github.png build/example/github.png -f

mv build/example/exampleExec.html build/example/index.html

sed -i 's#<title>exampleExec</title>#<title>QML Spatial UI | Kidev.org<\/title><link rel="icon" href="favicon.ico" type="image/x-icon">#g' build/example/index.html
sed -i "s#<strong>Qt for WebAssembly: exampleExec</strong>#<h1 style='color:\#ffffff;'><strong>QML Spatial UI</strong></h1><span style='color:\#ffffff;'>Written by Kidev using Qt</span><br><br><img src='qtlogo.svg' width='320' height='200' style='display:block'>#g" build/example/index.html
sed -i "s# height: 100% }# height: 100%; background-color:\#01010c; }#g" build/example/index.html
sed -i 's#<img src="qtlogo.svg" width="320" height="200" style="display:block"></img>#<img src="logo.png" width="320" height="320" style="display:block">#g' build/example/index.html
sed -i 's#<div id="qtstatus">#<div id="qtstatus" style="color:\#ffffff; font-weight:bold">#g' build/example/index.html
sed -i 's#undefined ? ` with code ` :#undefined ? ` with code ${exitData.code}` :#g' build/example/index.html
sed -i 's#undefined ? ` ()` :#undefined ? `<br><span style="color:\#ff0000">Error: ${exitData.text}</span><br>Server missing COOP and COEP headers, or unsupported browser` :#g' build/example/index.html
sed -i 's/\/\*.*\*\///g' build/example/index.html
sed -i '/<!--/,/-->/d' build/example/index.html

rm -rf build/example/.*
rm -rf build/example/CMakeFiles
rm -rf build/example/example
rm -rf build/example/exampleExec_autogen
rm -rf build/example/meta_types
rm -rf build/example/qmltypes
rm -f build/example/cmake_install.cmake
rm -f build/example/*.cpp

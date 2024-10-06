export QT_ROOT="${QT_ROOT:-/opt/Qt}"
export QT_VERSION="${QT_VERSION:-6.6.0}"

export QT_ROOT_GCC="${QT_ROOT}/${QT_VERSION}/gcc_64"

mkdir -p build
cmake -G Ninja -S . -B build -DCMAKE_PREFIX_PATH=${QT_ROOT_GCC} -DBUILD_EXAMPLE=ON
cmake --build build/

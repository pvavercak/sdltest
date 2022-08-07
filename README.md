# SDL test

## Build on Windows or Linux:
```bash
cd <repo>
mkdir build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --config Release -j8
```

## Build on MacOS:
```bash
cd <repo>
mkdir build
cd build
cmake -G Ninja -DCMAKE_OSX_ARCHITECTURES:STRING="x86_64;arm64" -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --config Release -j8
```

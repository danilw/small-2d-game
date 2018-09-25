# 2d Game
**what is it** one more try of game coding with GLSL and box2d, not using any game engines

**play** [live](https://danilw.github.io/small-2d-game/2dgamii.html)

original GLSL source in *glsl* folder (soon)

**binary builds** added *binary* builds for [Linux_64bit(gcc)](https://danilw.github.io/small-2d-game/linux_64.zip), to launch on Linux use *LD_LIBRARY_PATH=. ./2dgamii* , and [Windows_64bit(VS2017)](https://danilw.github.io/small-2d-game/windows_64.zip)

### Building

1. clone this [nanogui wasm](https://github.com/danilw/nanogui-GLES-wasm)
2. put files from *nanogui_mod* folder to *nanogui-GLES-wasm* 
3. build *nanovg.bc* and *nanogui.bc* in *nanogui-GLES-wasm* and move them to this project
4. clone this [box2d.js](https://github.com/kripken/box2d.js) and build *box2d.bc*
5. build this project *small-2d-game* using this command
```
em++ -DNANOVG_GLES3_IMPLEMENTATION -DGLFW_INCLUDE_ES3 -DGLFW_INCLUDE_GLEXT -DNANOGUI_LINUX -Iinclude/ -Iext/Box2D/ -Iext/nanovg/ -Iext/eigen/ box2d.bc nanogui.bc mii2d.cpp --std=c++11 -O3 -lGL -lGLU -lm -lGLEW -s USE_GLFW=3 -s FULL_ES3=1 -s USE_WEBGL2=1 -s WASM=1 -s ALLOW_MEMORY_GROWTH=1 -o build/2dgamii.html --shell-file shell_minimal.html --no-heap-copy --preload-file ./shaders

```

### Video
[![2dg](scr)](yt)

### Screenshot
![2dg](https://danilw.github.io/small-2d-game/scr.png)

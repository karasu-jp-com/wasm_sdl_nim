withDir "wasm_sdl02":
  exec("nim c -d:debug -o:../bin/wasm_sdl02.js wasm_sdl02.nim")
  # Windows以外のOSの場合、適当に書き換えて
  exec("cmd /C copy /Y ..\\bin\\wasm_sdl02.* .\\test")

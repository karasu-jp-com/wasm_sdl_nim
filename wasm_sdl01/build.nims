withDir "wasm_sdl01":
  exec("nim c -d:debug -o:../bin/wasm_sdl01.js wasm_sdl01.nim")
  # Windows以外のOSの場合、適当に書き換えて
  exec("cmd /C copy /Y ..\\bin\\wasm_sdl01.* .\\test")

withDir "wasm_sdl03":
  exec("nim c -d:debug -o:../bin/wasm_sdl03.js wasm_sdl03.nim")
  # Windows以外のOSの場合、適当に書き換えて
  exec("cmd /C copy /Y ..\\bin\\wasm_sdl03.* .\\test")

import jsbind/emscripten
import sdl2, sdl2/image as img

proc loadData()

const
  cScr_w = 255
  cScr_h = 255

var
  window:sdl2.WindowPtr
  renderer:sdl2.RendererPtr
  kani:TexturePtr
  logo:TexturePtr
  mainLoop:proc() = loadData

#######################################
# mainLoop_Base
#######################################
proc maiLoop_Base() {.cdecl.} =
  mainLoop()

#######################################
# render
#######################################
proc renderScreen() =
  renderer.setDrawColor(255, 128, 0, 255)
  renderer.clear()

  var rect:sdl2.Rect
  rect = (
    x: cint(0),
    y: cint((cScr_h - cScr_w*480/640)/2),
    w: cint(cScr_w),
    h: cint(cScr_w*480/640)
  )
  discard renderer.copy(kani, nil, rect.addr)

  rect = (
    x: cint(0),
    y: cint((cScr_h - cScr_w*48/600)/2),
    w: cint(cScr_w),
    h: cint(cScr_w*48/600)
  )
  discard renderer.copy(logo, nil, rect.addr)

  renderer.present

#######################################
# loadData
#######################################
proc loadData() =
  var loadCount = 0
  proc loadSuccess(tex: var TexturePtr, data: pointer, sz: cint)

  mainLoop = proc() = discard

  discard sdl2.createWindowAndRenderer(cScr_w, cScr_h, 0, window, renderer)

  emscripten_async_wget_data("../../assets/kani.png"
    , proc(data: pointer, sz: cint) =
        echo "emscripten_async_wget_data Success. kani.png"
        loadSuccess(kani, data, sz)
    , proc() =
        echo "emscripten_async_wget_data Falt. kani.png"
  )

  emscripten_async_wget_data("../../assets/nim_sdl_test.png"
    , proc(data: pointer, sz: cint) =
        echo "emscripten_async_wget_data Success. nim_sdl_test.png"
        loadSuccess(logo, data, sz)
    , proc() =
        echo "emscripten_async_wget_data Falt. nim_sdl_test.png"
  )

  proc loadSuccess(tex: var TexturePtr, data: pointer, sz: cint) =
    let rw: RWopsPtr = rwFromMem(data, sz)
    tex = img.loadTexture_RW(renderer, rw, 1)
    if tex != nil:
        echo "img.loadTexture_RW Success."
    else:
        echo "img.loadTexture_RW Fault."
        return

    inc(loadCount)
    if loadCount == 2:
      mainLoop = renderScreen

#######################################
# main
#######################################
sdl2.init(INIT_VIDEO)
discard img.init(IMG_INIT_PNG)

const simulate_infinite_loop = 1
const fps = -1
emscripten_set_main_loop(maiLoop_Base, fps, simulate_infinite_loop)

if(kani != nil): kani.destroy
if(logo != nil): logo.destroy
if(renderer != nil): renderer.destroy
if(window != nil): window.destroyWindow

img.quit()
sdl2.quit()

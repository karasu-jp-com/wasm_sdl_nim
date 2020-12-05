import jsbind/emscripten
import sdl2, sdl2/image as img

const
  cScr_w = 255
  cScr_h = 255
  file_name1 = "kani.png"
  file_name2 = "nim_sdl_test.png"

var
  window:sdl2.WindowPtr
  renderer:sdl2.RendererPtr
  kani:TexturePtr
  logo:TexturePtr
  is_first = true

#######################################
# main loop
#######################################
proc mailoop() {.cdecl.} =
  if is_first:
    is_first = false
    discard sdl2.createWindowAndRenderer(cScr_w, cScr_h, 0, window, renderer)
    kani = renderer.loadTexture(file_name1)
    echo "renderer.loadTexture " &
      (if(kani != nil):"Success" else: "Failure") & ". " & file_name1
    logo = renderer.loadTexture(file_name2)
    echo "renderer.loadTexture " &
      (if(logo != nil):"Success" else: "Failure") & ". " & file_name2

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
# main
#######################################
sdl2.init(INIT_VIDEO)
discard img.init(IMG_INIT_PNG)

const simulate_infinite_loop = 1
const fps = -1
emscripten_set_main_loop(mailoop, fps, simulate_infinite_loop)

if(kani != nil): kani.destroy
if(logo != nil): logo.destroy
if(renderer != nil): renderer.destroy
if(window != nil): window.destroyWindow

img.quit()
sdl2.quit()

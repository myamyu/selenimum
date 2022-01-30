import json
import session, rect

proc getWindowRect*(session: SeleniumSession): Rect =
  ## Get current window's location and size.
  let resp = session.get("/window/rect")
  let obj = resp{"value"}
  return Rect(
    x: obj{"x"}.getInt(),
    y: obj{"y"}.getInt(),
    width: obj{"width"}.getInt(),
    height: obj{"height"}.getInt(),
  )

## TODO
## ---------
##
## * newWindow https://w3c.github.io/webdriver/#dfn-new-window
## * closeWindow https://w3c.github.io/webdriver/#dfn-close-window
## * switchToWindow https://w3c.github.io/webdriver/#dfn-switch-to-window
## * setWindowRect https://w3c.github.io/webdriver/#dfn-set-window-rect
## * maximizeWindow https://w3c.github.io/webdriver/#dfn-maximize-window
## * minimizeWindow https://w3c.github.io/webdriver/#dfn-minimize-window
## * fullscreenWindow https://w3c.github.io/webdriver/#dfn-fullscreen-window
## * getWindowHandle https://w3c.github.io/webdriver/#dfn-get-window-handle
## * getWindowHandles https://w3c.github.io/webdriver/#dfn-get-window-handles
##

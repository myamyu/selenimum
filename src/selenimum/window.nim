import json
import session, rect

#[
  TODO: get window handle
  https://w3c.github.io/webdriver/#dfn-get-window-handle
]#

#[
  TODO: close window
  https://w3c.github.io/webdriver/#dfn-close-window
]#

#[
  TODO: switch to window
  https://w3c.github.io/webdriver/#dfn-switch-to-window
]#

#[
  TODO: get window handles
  https://w3c.github.io/webdriver/#dfn-get-window-handles
]#

#[
  TODO: new window
  https://w3c.github.io/webdriver/#dfn-new-window
]#

#[
  get window rect
  https://w3c.github.io/webdriver/#dfn-get-window-rect
]#
proc getWindowRect*(session: SeleniumSession): Rect =
  let resp = session.get("/window/rect")
  let obj = resp{"value"}
  return Rect(
    x: obj{"x"}.getInt(),
    y: obj{"y"}.getInt(),
    width: obj{"width"}.getInt(),
    height: obj{"height"}.getInt(),
  )

#[
  TODO: set window rect
  https://w3c.github.io/webdriver/#dfn-set-window-rect
]#

#[
  TODO: maximize window
  https://w3c.github.io/webdriver/#dfn-maximize-window
]#

#[
  TODO: minimize window
  https://w3c.github.io/webdriver/#dfn-minimize-window
]#

#[
  TODO: fullscreen window
  https://w3c.github.io/webdriver/#dfn-fullscreen-window
]#

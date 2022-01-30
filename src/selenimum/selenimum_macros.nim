import macros, json
import webdriver, session, element

macro selenium*(baseUrl: string, body: untyped): untyped =
  ## Start selenium block.
  let driver = newIdentNode("driver")
  quote do:
    block:
      let `driver` = newSeleniumWebDriver(baseUrl = `baseUrl`)
      `body`

macro chrome*(body: untyped): untyped =
  ## Start chrome session block.
  let driver = newIdentNode("driver")
  let session = newIdentNode("session")
  quote do:
    block:
      let `session` = `driver`.newSession()
      try:
        `body`
      finally:
        `session`.deleteSession()

macro firefox*(body: untyped): untyped =
  ## Start firefox session block.
  let driver = newIdentNode("driver")
  let session = newIdentNode("session")
  quote do:
    block:
      let `session` = `driver`.newSession(%*{
        "desiredCapabilities": {
          "browserName": "firefox"
        },
        "requiredCapabilities": {}
      })
      try:
        `body`
      finally:
        `session`.deleteSession()

macro navigateTo*(url: string): untyped =
  ## Navigate to url.
  let session = newIdentNode("session")
  quote do:
    `session`.navigateTo(`url`)

macro back*(): untyped =
  let session = newIdentNode("session")
  quote do:
    `session`.back()

macro forward*(): untyped =
  let session = newIdentNode("session")
  quote do:
    `session`.forward()

macro refresh*(): untyped =
  let session = newIdentNode("session")
  quote do:
    `session`.refresh()

macro setValue*(query: string, val: string): untyped =
  let session = newIdentNode("session")
  let e = newIdentNode("e")
  quote do:
    block:
      let `e` = `session`.findElement(query = `query`)
      `e`.value = `val`

macro click*(query: string): untyped =
  let session = newIdentNode("session")
  let e = newIdentNode("e")
  quote do:
    block:
      let `e` = `session`.findElement(query = `query`)
      `e`.click()

macro getText*(query: string): string =
  let session = newIdentNode("session")
  let e = newIdentNode("e")
  quote do:
    block:
      let `e` = `session`.findElement(query = `query`)
      `e`.getText()

macro elements*(query: string, body: untyped): untyped =
  ## Start elements loop block.
  let session = newIdentNode("session")
  let index = newIdentNode("index")
  let element = newIdentNode("element")
  quote do:
    block:
      for `index`, `element` in `session`.findElements(query = `query`):
        `body`

macro screenshot*(filePath: string): untyped =
  let session = newIdentNode("session")
  quote do:
    `session`.saveScreenshot(`filePath`)

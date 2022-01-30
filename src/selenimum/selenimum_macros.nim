import macros, json
import webdriver, session

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

macro setValue*(query: string, val: string): untyped =
  let session = newIdentNode("session")
  let e = newIdentNode("e")
  quote do:
    block:
      let `e` = `session`.findElement(query = `query`)
      `e`.setValue(`val`)

macro click*(query: string): untyped =
  let session = newIdentNode("session")
  let e = newIdentNode("e")
  quote do:
    block:
      let `e` = `session`.findElement(query = `query`)
      `e`.click()

macro elements*(query: string, body: untyped): untyped =
  let session = newIdentNode("session")
  let index = newIdentNode("index")
  let element = newIdentNode("element")
  quote do:
    block:
      for `index`, `element` in `session`.findElements(query = `query`):
        `body`

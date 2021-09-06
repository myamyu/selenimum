import json, strformat
import webdriver, errors

type
  SeleniumSession* = object
    driver: SeleniumWebDriver
    id*: string

  Timeouts* = object
    script*: int
    pageLoad*: int
    implicit*: int

let
  defaultCapabilities* = %*{
    "desiredCapabilities": {
      "browserName": "chrome"
    },
    "requiredCapabilities": {}
  }

#[
  create new session.
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#session
]#
proc newSession*(driver: SeleniumWebDriver, capabilities:JsonNode = defaultCapabilities): SeleniumSession =
  # check status
  let status = driver.status()
  if not status.ready:
    raise newException(SeleniumProtocolException, "selenium is not ready.")

  # create session
  let sessionId = driver.post("/session", capabilities){"value", "sessionId"}
  if sessionId.isNil():
    raise newException(SeleniumProtocolException, "failed to create session.")

  return SeleniumSession(driver: driver, id: sessionId.getStr())

#[
  get exists session
]#
proc getSession*(driver: SeleniumWebDriver, sessionId: string): SeleniumSession =
  return SeleniumSession(driver: driver, id: sessionId)

#[
  delete Selenium session
]#
proc deleteSession*(session: SeleniumSession) =
  let driver = session.driver
  driver.delete(fmt"/session/{session.id}")

# send GET request to selenium with session
proc get*(session: SeleniumSession, path: string): JsonNode =
  let driver = session.driver
  result = driver.get(fmt"/session/{session.id}{path}")

# send POST request to selenium with session
proc post*(session: SeleniumSession, path: string, body: JsonNode): JsonNode =
  let driver = session.driver
  result = driver.post(fmt"/session/{session.id}{path}", body)

# send DELETE request to selenium with session
proc delete*(session: SeleniumSession, path: string) =
  let driver = session.driver
  driver.delete(fmt"/session/{session.id}{path}")

#[
  get timeouts
  https://w3c.github.io/webdriver/#dfn-get-timeouts
]#
proc getTimeouts*(session: SeleniumSession): Timeouts =
  let resp = session.get("/timeouts")
  let obj = resp{"value"}
  return Timeouts(
    script: obj{"script"}.getInt(),
    pageLoad: obj{"pageLoad"}.getInt(),
    implicit: obj{"implicit"}.getInt(),
  )

#[
  TODO: set timeouts
  https://w3c.github.io/webdriver/#dfn-set-timeouts
]#

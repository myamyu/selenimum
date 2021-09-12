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

proc newSession*(driver: SeleniumWebDriver, capabilities:JsonNode = defaultCapabilities): SeleniumSession =
  ## Create new Selenium session.
  ## 
  ## Default capabilities is use chrome.
  ## 
  ## If want to use firefox:
  ## 
  ## .. code-block:: Nim
  ##  let 
  ##    capabilities = %*{
  ##      "desiredCapabilities": {
  ##        "browserName": "firefox"
  ##      },
  ##      "requiredCapabilities": {}
  ##    }
  ##    session = driver.newSession(capabilities=capabilities)
  ## 
  ## See https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#capabilities-json-object for capabilities.
  ## 


  # check status
  let status = driver.status()
  if not status.ready:
    raise newException(SeleniumProtocolException, "selenium is not ready.")

  # create session
  let sessionId = driver.post("/session", capabilities){"value", "sessionId"}
  if sessionId.isNil():
    raise newException(SeleniumProtocolException, "failed to create session.")

  return SeleniumSession(driver: driver, id: sessionId.getStr())

proc deleteSession*(session: SeleniumSession) =
  ## Delete Selenium session.
  let driver = session.driver
  driver.delete(fmt"/session/{session.id}")

proc get*(session: SeleniumSession, path: string): JsonNode =
  ## Call selenium API GET method for Session.
  ## 
  ## If path = `"/url"` , call `GET /session/{sessionId}/url`.
  ## 
  let driver = session.driver
  result = driver.get(fmt"/session/{session.id}{path}")

proc post*(session: SeleniumSession, path: string, body: JsonNode): JsonNode =
  ## Call selenium API POST method for Session.
  ## 
  ## If path = `"/url"` , call `POST /session/{sessionId}/url`.
  ## 
  let driver = session.driver
  result = driver.post(fmt"/session/{session.id}{path}", body)

proc delete*(session: SeleniumSession, path: string) =
  ## Call selenium API DELETE method for Session.
  ## 
  ## If path = `"/cookie"` , call `DELETE /session/{sessionId}/cookie`.
  ## 
  let driver = session.driver
  driver.delete(fmt"/session/{session.id}{path}")

proc getTimeouts*(session: SeleniumSession): Timeouts =
  ## Get timeouts value.
  let resp = session.get("/timeouts")
  let obj = resp{"value"}
  return Timeouts(
    script: obj{"script"}.getInt(),
    pageLoad: obj{"pageLoad"}.getInt(),
    implicit: obj{"implicit"}.getInt(),
  )

## TODO
## --------
## 
## * setTimeouts https://w3c.github.io/webdriver/#dfn-set-timeouts
## 

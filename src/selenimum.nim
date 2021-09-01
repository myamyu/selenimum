import httpclient, uri, json, strformat

type
  SeleniumWebDriver* = ref object
    baseUrl*: Uri
    client*: HttpClient

  SeleniumSession* = object
    driver*: SeleniumWebDriver
    id*: string

  SeleniumWebDriverException* = object of CatchableError
  SeleniumProtocolException* = object of SeleniumWebDriverException

let
  defaultCapabilities* = %*{
    "desiredCapabilities": {
      "browserName": "firefox"
    },
    "requiredCapabilities": {}
  }

#[
  create new SeleniumWebDriver
]#
proc newSeleniumWebDriver*(baseUrl:string = "http://localhost:4444/wd/hub"): SeleniumWebDriver =
  SeleniumWebDriver(baseUrl: baseUrl.parseUri, client: newHttpClient())

# send GET request to selenium
proc get(driver: SeleniumWebDriver, path: string): JsonNode =
  let client = driver.client
  let baseUrl = driver.baseUrl
  let resp = client.getContent($(baseUrl / path))
  return parseJson(resp)

# send POST request to selenium
proc post(driver: SeleniumWebDriver, path: string, body: JsonNode): JsonNode =
  let client = driver.client
  let baseUrl = driver.baseUrl
  let resp = client.postContent($(baseUrl / path), $body)
  return parseJson(resp)  

# send DELETE request to selenium
proc delete(driver: SeleniumWebDriver, path: string): JsonNode =
  let client = driver.client
  let baseUrl = driver.baseUrl
  let resp = client.deleteContent($(baseUrl / path))
  return parseJson(resp)

#[
  create new session.
]#
proc newSession*(driver: SeleniumWebDriver, capabilities:JsonNode = defaultCapabilities): SeleniumSession =
  # check status
  let ready = driver.get("/status"){"value", "ready"}
  if ready.isNil():
    raise newException(SeleniumWebDriverException, "selenium API Error.")
  if not ready.getBool():
    raise newException(SeleniumProtocolException, "selenium is not ready.")

  # create session
  let sessionId = driver.post("/session", capabilities){"sessionId"}
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
  let state = driver.delete(fmt"/session/{session.id}"){"state"}
  if state.isNil() or state.getStr() != "success":
    raise newException(SeleniumProtocolException, "failed to delete session.")

# send GET request to selenium with session
proc get(session: SeleniumSession, path: string): JsonNode =
  let driver = session.driver
  result = driver.get(fmt"/session/{session.id}{path}")
  let state = result{"state"}
  if state.isNil() or state.getStr() != "success":
    raise newException(SeleniumProtocolException, "failed to get request with session.")

# send POST request to selenium with session
proc post(session: SeleniumSession, path: string, body: JsonNode): JsonNode =
  let driver = session.driver
  result = driver.post(fmt"/session/{session.id}{path}", body)
  let state = result{"state"}
  if state.isNil() or state.getStr() != "success":
    raise newException(SeleniumProtocolException, "failed to post request with session.")

# send DELETE request to selenium with session
proc delete(session: SeleniumSession, path: string): JsonNode =
  let driver = session.driver
  result = driver.delete(fmt"/session/{session.id}{path}")
  let state = result{"state"}
  if state.isNil() or state.getStr() != "success":
    raise newException(SeleniumProtocolException, "failed to delete request with session.")

#[
  TODO: get timeouts
  https://w3c.github.io/webdriver/#dfn-get-timeouts
]#

#[
  TODO: set timeouts
  https://w3c.github.io/webdriver/#dfn-set-timeouts
]#

#[
  navigate to url(by string)
  https://w3c.github.io/webdriver/#dfn-navigate-to
]#
proc navigateTo*(session: SeleniumSession, url: string) =
  discard session.post("/url", %*{"url": url})

#[
  navigate to url(by Uri)
  https://w3c.github.io/webdriver/#dfn-navigate-to
]#
proc navigateTo*(session: SeleniumSession, url: Uri) =
  discard session.post("/url", %*{"url": $url})

#[
  get current Url
  https://w3c.github.io/webdriver/#dfn-get-current-url
]#
proc getCurrentUrl*(session: SeleniumSession): Uri =
  let resp = session.get("/url")
  return resp{"value"}.getStr().parseUri()

#[
  TODO: back
  https://w3c.github.io/webdriver/#dfn-back
]#

#[
  TODO: forward
  https://w3c.github.io/webdriver/#dfn-forward
]#

#[
  TODO: refresh
  https://w3c.github.io/webdriver/#dfn-refresh
]#

#[
  TODO: get title
  https://w3c.github.io/webdriver/#dfn-get-title
]#

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
  TODO: switch to frame
  https://w3c.github.io/webdriver/#dfn-switch-to-frame
]#

#[
  TODO: switch to parent frame
  https://w3c.github.io/webdriver/#dfn-switch-to-parent-frame
]#

#[
  TODO: get window rect
  https://w3c.github.io/webdriver/#dfn-get-window-rect
]#

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

#[
  TODO: get active element
  https://w3c.github.io/webdriver/#dfn-get-active-element
]#

#[
  TODO: get element shadow root
  https://w3c.github.io/webdriver/#dfn-get-element-shadow-root
]#

#[
  TODO: find element
  https://w3c.github.io/webdriver/#dfn-find-element
]#

#[
  TODO: find elements
  https://w3c.github.io/webdriver/#dfn-find-elements
]#

#[
  TODO: find element from element
  https://w3c.github.io/webdriver/#dfn-find-element-from-element
]#

#[
  TODO: find elements from element
  https://w3c.github.io/webdriver/#dfn-find-elements-from-element
]#

#[
  TODO: find element from shadow root
  https://w3c.github.io/webdriver/#dfn-find-element-from-shadow-root
]#

#[
  TODO: find elements from shadow root
  https://w3c.github.io/webdriver/#dfn-find-elements-from-shadow-root
]#

#[
  TODO: is element selected
  https://w3c.github.io/webdriver/#dfn-is-element-selected
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-element-attribute
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-element-property
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-element-css-value
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-element-text
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-element-tag-name
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-element-rect
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-is-element-enabled
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-computed-role
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-computed-label
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-element-click
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-element-clear
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-element-send-keys
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-page-source
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-execute-script
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-execute-async-script
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-all-cookies
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-named-cookie
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-adding-a-cookie
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-delete-cookie
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-delete-all-cookies
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-perform-actions
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-release-actions
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-dismiss-alert
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-accept-alert
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-alert-text
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-send-alert-text
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-take-screenshot
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-take-element-screenshot
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-print-page
]#

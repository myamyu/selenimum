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
  navigate to url
]#
proc navigateTo*(session: SeleniumSession, url: string) =
  discard session.post("/url", %*{"url": url})

#[
  navigate to url
]#
proc navigateTo*(session: SeleniumSession, url: Uri) =
  discard session.post("/url", %*{"url": $url})

#[
  Get Current Url
]#
proc getCurrentUrl*(session: SeleniumSession): Uri =
  let resp = session.get("/url")
  return resp{"value"}.getStr().parseUri()

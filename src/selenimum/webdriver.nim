import httpclient, uri, json
import errors

type
  SeleniumWebDriver* = ref object
    baseUrl*: Uri
    client*: HttpClient

  SeleniumStatus* = object
    ready*: bool
    message*: string
    buildVersion*: string

proc newSeleniumWebDriver*(baseUrl: string = "http://localhost:4444/wd/hub", timeout: int = 15000): SeleniumWebDriver =
  ## Create new WebDriver for Selenium.
  ##
  ## Params
  ## ^^^^^^^^
  ##
  ## `baseUrl`
  ##    Your Selenium-hub's URL.
  ## `timeout`
  ##    The amount of time of request timeout, in milliseconds.
  ##
  SeleniumWebDriver(baseUrl: baseUrl.parseUri, client: newHttpClient(timeout = timeout))

proc get*(driver: SeleniumWebDriver, path: string): JsonNode =
  ## Call selenium API GET method.
  let client = driver.client
  let baseUrl = driver.baseUrl
  let resp = client.get($(baseUrl / path))
  resp.checkHttpResponse()
  let body = resp.body
  return parseJson(body)

proc post*(driver: SeleniumWebDriver, path: string, body: JsonNode): JsonNode =
  ## Call selenium API POST method.
  let client = driver.client
  let baseUrl = driver.baseUrl
  let resp = client.post($(baseUrl / path), $body)
  resp.checkHttpResponse()
  let body = resp.body
  return parseJson(body)

proc delete*(driver: SeleniumWebDriver, path: string) =
  ## Call selenium API DELETE method.
  let client = driver.client
  let baseUrl = driver.baseUrl
  let resp = client.delete($(baseUrl / path))
  resp.checkHttpResponse()

proc status*(driver: SeleniumWebDriver): SeleniumStatus =
  ## Get Selenium's status.
  let resp = driver.get("/status")
  let obj = resp{"value"}
  return SeleniumStatus(
    ready: obj{"ready"}.getBool(),
    message: obj{"message"}.getStr(),
    buildVersion: obj{"build", "version"}.getStr(),
  )

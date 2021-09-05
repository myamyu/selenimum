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

#[
  create new SeleniumWebDriver
]#
proc newSeleniumWebDriver*(baseUrl:string = "http://localhost:4444/wd/hub", timeout:int = 10000): SeleniumWebDriver =
  SeleniumWebDriver(baseUrl: baseUrl.parseUri, client: newHttpClient(timeout = timeout))

# send GET request to selenium
proc get*(driver: SeleniumWebDriver, path: string): JsonNode =
  let client = driver.client
  let baseUrl = driver.baseUrl
  let resp = client.get($(baseUrl / path))
  resp.checkHttpResponse()
  let body = resp.body
  return parseJson(body)

# send POST request to selenium
proc post*(driver: SeleniumWebDriver, path: string, body: JsonNode): JsonNode =
  let client = driver.client
  let baseUrl = driver.baseUrl
  let resp = client.post($(baseUrl / path), $body)
  resp.checkHttpResponse()
  let body = resp.body
  return parseJson(body)

# send DELETE request to selenium
proc delete*(driver: SeleniumWebDriver, path: string) =
  let client = driver.client
  let baseUrl = driver.baseUrl
  let resp = client.delete($(baseUrl / path))
  resp.checkHttpResponse()

#[
  status
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#status
]#
proc status*(driver: SeleniumWebDriver): SeleniumStatus =
  let resp = driver.get("/status")
  let obj = resp{"value"}
  return SeleniumStatus(
    ready: obj{"ready"}.getBool(),
    message: obj{"message"}.getStr(),
    buildVersion: obj{"build", "version"}.getStr(),
  )

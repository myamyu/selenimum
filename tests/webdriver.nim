import selenimum

const
  testSiteOrigin* = "http://test-site"

type TestWebDriver* = object
  ## WebDriver for test.
  webDriver*: SeleniumWebDriver

proc newWebDriver*(): TestWebDriver =
  ## create WebDriver for test.
  return TestWebDriver(
    webDriver: newSeleniumWebDriver(baseUrl="http://selenium-hub:4444/wd/hub")
  )

proc newSession*(driver: TestWebDriver): SeleniumSession =
  ## create session.
  return driver.webDriver.newSession()

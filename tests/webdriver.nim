import selenimum

const
  testSiteOrigin* = "http://test-site"

type TestWebDriver* = object
  webDriver*: SeleniumWebDriver

proc newWebDriver*(): TestWebDriver =
  return TestWebDriver(
    webDriver: newSeleniumWebDriver(baseUrl="http://selenium-hub:4444/wd/hub")
  )

proc newSession*(driver: TestWebDriver): SeleniumSession =
  return driver.webDriver.newSession()

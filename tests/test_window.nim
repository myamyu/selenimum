import unittest
import ./webdriver, selenimum

suite "test window":
  let driver = newWebDriver()
  var session: SeleniumSession

  setup:
    session = driver.newSession()
  
  teardown:
    session.deleteSession()

  test "get window rect":
    let rect = session.getWindowRect()
    check(rect.height > 0)
    check(rect.width > 0)

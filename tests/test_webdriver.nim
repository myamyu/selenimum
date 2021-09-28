import unittest, net
import selenimum

suite "test webdriver":

  test "status":
    let driver = newSeleniumWebDriver(baseUrl="http://selenium-hub:4444/wd/hub")
    let status = driver.status()
    echo $status
    check(status.ready)

  test "timeout":
    let driver = newSeleniumWebDriver(baseUrl="http://selenium-hub:4444/wd/hub", timeout=0)
    expect(TimeoutError):
      discard driver.status()

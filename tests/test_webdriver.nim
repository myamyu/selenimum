import unittest, net
import selenimum

suite "test webdriver":

  test "status":
    let driver = newSeleniumWebDriver(baseUrl="http://selenium-hub:4444/wd/hub")
    let status = driver.status()
    echo $status
    check(status.ready)

  test "timeout":
    let driver = newSeleniumWebDriver(baseUrl="http://selenium-hub:4444/wd/hub", timeout=1)
    expect(TimeoutError):
      discard driver.status()

  test "unknown endpoint":
    let driver = newSeleniumWebDriver(baseUrl="http://selenium-hub:8888/wd/hub")
    try:
      discard driver.status()
    except OSError:
      check(getCurrentExceptionMsg() == "Connection refused")

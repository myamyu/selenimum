import unittest, json, os
import selenimum

suite "create new session":
  let driver = newSeleniumWebDriver(baseUrl="http://selenium-hub:4444/wd/hub")

  test "chrome session":
    var session = driver.newSession()
    try:
      check(session.id != "")
    except:
      discard
    finally:
      session.deleteSession()

  test "firefox session":
    var session = driver.newSession(%*{
      "desiredCapabilities": {
        "browserName": "firefox"
      },
      "requiredCapabilities": {}
    })
    try:
      check(session.id != "")
    except:
      discard
    finally:
      session.deleteSession()

suite "create session error":
  let driver = newSeleniumWebDriver(baseUrl="http://selenium-hub:4444/wd/hub")

  test "unknown browser":
    expect(SeleniumServerException):
      var session = driver.newSession(%*{
        "desiredCapabilities": {
          "browserName": "unknown"
        },
        "requiredCapabilities": {}
      })
      session.deleteSession()

suite "delete session error":
  let driver = newSeleniumWebDriver(baseUrl="http://selenium-hub:4444/wd/hub")

  test "delete deleted session":
    var session = driver.newSession()
    session.deleteSession()
    sleep(300)
    expect(SeleniumServerException):
      session.deleteSession()

suite "get timeout":
  let driver = newSeleniumWebDriver(baseUrl="http://selenium-hub:4444/wd/hub")

  test "get timeout":
    var session = driver.newSession()
    try:
      var t = session.getTimeouts()
      check(t.script > 0)
      check(t.pageLoad > 0)
    except:
      discard
    finally:
      session.deleteSession()

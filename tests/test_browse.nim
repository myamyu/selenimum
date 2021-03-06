import unittest, uri, strformat, strutils, os
import ./webdriver, selenimum

suite "test browse":
  let driver = newWebDriver()
  var session: SeleniumSession

  setup:
    session = driver.newSession()
  
  teardown:
    session.deleteSession()

  test "get current url":
    let url = session.getCurrentUrl()
    check($url == "data:,")

  test "navigate to url":
    checkpoint("navigateTo by string")
    session.navigateTo(fmt"{testSiteOrigin}/")
    var url = session.getCurrentUrl()
    check($url == fmt"{testSiteOrigin}/")

    checkpoint("navigateTo by Uri")
    session.navigateTo(parseUri(fmt"{testSiteOrigin}/index.html"))
    url = session.getCurrentUrl()
    check($url == fmt"{testSiteOrigin}/index.html")

  test "get page title":
    session.navigateTo(fmt"{testSiteOrigin}/")
    let title = session.getTitle()
    check(title == "Test Page Index")

  test "back and forward":
    session.navigateTo(fmt"{testSiteOrigin}/")
    let url1 = session.getCurrentUrl()
    session.navigateTo(fmt"{testSiteOrigin}/index2.html")
    let url2 = session.getCurrentUrl()
    checkPoint("back")
    session.back()
    check($session.getCurrentUrl() == $url1)
    checkPoint("forward")
    session.forward()
    check($session.getCurrentUrl() == $url2)

  test "refresh":
    session.navigateTo(fmt"{testSiteOrigin}/")
    session.refresh()
    check($session.getCurrentUrl() == fmt"{testSiteOrigin}/")

  test "get page source":
    session.navigateTo(fmt"{testSiteOrigin}/")
    let source = session.getPageSource()
    check(source.find("this is comment") >= 0)

  test "screenshot":
    session.navigateTo(fmt"{testSiteOrigin}/")
    session.saveScreenshot("./testpage.png")
    checkpoint("check file expsts")
    check(fileExists("./testpage.png"))
    checkpoint("check file size")
    check(getFileSize("./testpage.png") > 0)

suite "test browse error case":
  let driver = newWebDriver()
  var session: SeleniumSession

  setup:
    session = driver.newSession()
  
  teardown:
    session.deleteSession()

  test "navigate to url":
    checkpoint("navigateTo by string")
    expect(SeleniumServerException):
      session.navigateTo(fmt"{testSiteOrigin}1/")

    checkpoint("navigateTo by Uri")
    expect(SeleniumServerException):
      session.navigateTo(parseUri(fmt"{testSiteOrigin}1/"))

import unittest, uri, strformat
import selenimum

suite "test browse":
  const
    testSiteOrigin = "http://test-site"
  let
    driver = newSeleniumWebDriver(baseUrl="http://selenium-hub:4444/wd/hub")
  
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

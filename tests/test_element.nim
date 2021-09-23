import unittest, strformat
import ./webdriver, selenimum

suite "test element":
  let driver = newWebDriver()
  var session: SeleniumSession

  setup:
    session = driver.newSession()
  
  teardown:
    session.deleteSession()

  test "find element":
    session.navigateTo(fmt"{testSiteOrigin}/")
    var elem: Element

    checkpoint("css selector")
    elem = session.findElementBySelector(".main > section > h2")
    check(elem.getText() == "Test section 1")

    checkpoint("ID")
    elem = session.findElementById("pageTitle")
    check(elem.getText() == "Test Page")

    checkpoint("xpath")
    elem = session.findElementByXPath("//h2")
    check(elem.getText() == "Test section 1")

    checkpoint("tag name")
    elem = session.findElementByTagName("h1")
    check(elem.getText() == "Test Page")

  test "find elements":
    session.navigateTo(fmt"{testSiteOrigin}/")
    var elems: seq[Element]

    checkpoint("css selector")
    elems = session.findElementsBySelector("#navigate > li")
    check(len(elems) == 3)

    checkpoint("xpath")
    elems = session.findElementsByXPath("//*[@id='navigate']/li")
    check(len(elems) == 3)

    checkpoint("tag name")
    elems = session.findElementsByTagName("li")
    check(len(elems) == 3)

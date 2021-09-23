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

  test "find element from element":
    session.navigateTo(fmt"{testSiteOrigin}/")
    let section = session.findElementByTagName("section")

    var elem: Element

    checkpoint("css selector")
    elem = section.findElementBySelector("h2 + p")
    check(elem.getText() == "This is section.")

    checkpoint("ID")
    elem = section.findElementById("sec1Title")
    check(elem.getText() == "Test section 1")

    checkpoint("xpath")
    elem = section.findElementByXPath("//h2")
    check(elem.getText() == "Test section 1")

    checkpoint("tag name")
    elem = section.findElementByTagName("p")
    check(elem.getText() == "This is section.")

  test "find elements from element":
    session.navigateTo(fmt"{testSiteOrigin}/")
    let ul = session.findElementByTagName("ul")

    var elems: seq[Element]

    checkpoint("css selector")
    elems = ul.findElementsBySelector("li > span")
    check(len(elems) == 2)

    checkpoint("xpath")
    elems = ul.findElementsByXPath("//li/span")
    check(len(elems) == 2)

    checkpoint("tag name")
    elems = ul.findElementsByTagName("span")
    check(len(elems) == 2)

  test "click":
    # TODO test
    discard
  
  test "get tag name":
    # TODO test
    discard

  test "set/clear value":
    # TODO test
    discard

  test "get attribute value":
    # TODO test
    discard

suite "test element error case":
  # TODO test
  discard

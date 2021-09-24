import unittest, strformat, os, uri
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
    session.navigateTo(fmt"{testSiteOrigin}/")
    var elem: Element

    elem = session.findElement(query="#navigate > li > a")
    elem.click()
    sleep(300) # wait for next page.
    check($session.getCurrentUrl() == fmt"{testSiteOrigin}/index2.html")

  test "get attribute value":
    session.navigateTo(fmt"{testSiteOrigin}/")
    var elem: Element
    
    elem = session.findElement(query="#navigate > li > a")
    check(elem.getAttributeValue("href") == "index2.html")
  
  test "get tag name":
    session.navigateTo(fmt"{testSiteOrigin}/")
    var elem: Element

    elem = session.findElementById("main")
    check(elem.getTagName() == "div")

  test "set/clear value":
    session.navigateTo(fmt"{testSiteOrigin}/")
    var elem: Element

    checkpoint("clear value")
    elem = session.findElement(query="#testForm > input[name=test1]")
    elem.clearValue()
    session.findElement(query="#testForm > input[type=submit]").click()
    sleep(300) # wait for next page.
    check($session.getCurrentUrl() == fmt"{testSiteOrigin}/?test1=")

    checkpoint("set value")
    echo "[TODO] write test when set value issue resolved. https://github.com/myamyu/selenimum/issues/22"

suite "test element error case":
  let driver = newWebDriver()
  var session: SeleniumSession

  setup:
    session = driver.newSession()
  
  teardown:
    session.deleteSession()

  test "not found element":
    session.navigateTo(fmt"{testSiteOrigin}/")
    var elem: Element

    expect(SeleniumNotFoundException):
      elem = session.findElement(query=".main > div")


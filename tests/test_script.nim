import unittest, strformat
import ./webdriver, selenimum

suite "test script":
  let driver = newWebDriver()
  var session: SeleniumSession

  setup:
    session = driver.newSession()
  
  teardown:
    session.deleteSession()

  test "run script":
    session.navigateTo(fmt"{testSiteOrigin}/")

    let script = """
(function(){
  const d = document;
  const h1 = d.getElementById('pageTitle');
  h1.textContent = 'Index of Test Page';
})();
"""
    session.executeScript(script)
    let elem = session.findElementById("pageTitle")
    check(elem.getText() == "Index of Test Page")

  test "error script":
    session.navigateTo(fmt"{testSiteOrigin}/")

    let script = """
(function(){
  const d = document;
  const h1 = d.getElementById('pageTitle');
  h1.textContent = 'Index of Test Page';
"""
    expect(SeleniumServerException):
      session.executeScript(script)

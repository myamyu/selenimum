import unittest, strformat
import ./webdriver, selenimum

suite "test cookie":
  let driver = newWebDriver()
  var session: SeleniumSession

  setup:
    session = driver.newSession()
  
  teardown:
    session.deleteSession()

  test "is empty":
    var cookie = Cookie()
    checkpoint("empty cookie")
    check(cookie.isEmpty)
    checkpoint("not empty cookie")
    cookie.name = "cookie1"
    cookie.value = "test cookie"
    check(not cookie.isEmpty)

  test "cookie set/remove":
    session.navigateTo(fmt"{testSiteOrigin}/")
    checkpoint("no cookies")
    check(len(session.getAllCookies()) == 0)

    checkpoint("set cookie")
    session.setCookie(Cookie(
      name: "testCookie",
      value: "test cookie",
      path: "/",
    ))
    check(len(session.getAllCookies()) == 1)
    session.refresh()
    check(len(session.getAllCookies()) == 1)

    checkpoint("get named cookie")
    var cookie = session.getNamedCookie("testCookie")
    check(not cookie.isEmpty)
    check(cookie.name == "testCookie")
    check(cookie.value == "test cookie")
    check(cookie.path == "/")

    session.setCookie(Cookie(
      name: "testCookie2",
      value: "test cookie 2",
      path: "/",
    ))
    session.setCookie(Cookie(
      name: "testCookie3",
      value: "test cookie 3",
      path: "/",
    ))
    check(len(session.getAllCookies()) == 3)

    checkpoint("remove cookie")
    session.deleteCookie("testCookie")
    check(len(session.getAllCookies()) == 2)
    cookie = session.getNamedCookie("testCookie")
    check(cookie.isEmpty)

    checkpoint("remove all cookie")
    session.deleteAllCookies()
    check(len(session.getAllCookies()) == 0)

  test "cookie on path":
    session.navigateTo(fmt"{testSiteOrigin}/path1/")
    session.setCookie(Cookie(
      name: "testCookie_path1",
      value: "test cookie",
      path: "/path1/",
    ))
    session.setCookie(Cookie(
      name: "testCookie_path2",
      value: "test cookie",
      path: "/",
    ))
    session.setCookie(Cookie(
      name: "testCookie_path3",
      value: "test cookie",
      path: "/path1/",
    ))
    check(len(session.getAllCookies()) == 3)

    session.navigateTo(fmt"{testSiteOrigin}/")
    check(len(session.getAllCookies()) == 1)
    var cookie = session.getNamedCookie("testCookie_path2")
    check(not cookie.isEmpty())
    check(cookie.name == "testCookie_path2")
    check(cookie.value == "test cookie")
    check(cookie.path == "/")

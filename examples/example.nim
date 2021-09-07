import selenimum, uri
import logging, strformat

const fmtStr = "$date $time - [$levelname] "
let logger = newConsoleLogger(fmtStr=fmtStr)
addHandler(logger)

proc main() =
  info("start the example.")

  let
    driver = newSeleniumWebDriver()
    session = driver.newSession()

  info(fmt"session is [{session.id}]")

  defer:
    info(fmt"delete session [{session.id}]")
    session.deleteSession()
    info("end of example.")

  try:
    info("Navigate to...")
    session.navigateTo("https://www.yahoo.co.jp/")
    info("Get URL...")
    var url = session.getCurrentUrl()
    debug(fmt"URL: {$url}")
    let title = session.getTitle()
    debug(fmt"title: {title}")
    let winRect = session.getWindowRect()
    debug(fmt"rect: {$winRect}")
    var cookie = session.getNamedCookie("__gads")
    if cookie.isEmpty:
      debug(fmt"cookie is empty.")
    else:
      debug(fmt"cookie: {$cookie}")
    session.back()
    url = session.getCurrentUrl()
    debug(fmt"URL: {$url}")
    session.forward()
    url = session.getCurrentUrl()
    debug(fmt"URL: {$url}")

    # cookie操作
    session.setCookie(Cookie(
      name: "hoge",
      value: "fuga",
    ))
    info("Cookie is created.")
    cookie = session.getNamedCookie("hoge")
    if cookie.isEmpty:
      debug(fmt"cookie is empty.")
    else:
      debug(fmt"cookie: {$cookie}")
    session.deleteCookie("hoge")
    info("Cookie is deleted.")
    cookie = session.getNamedCookie("hoge")
    if cookie.isEmpty:
      debug(fmt"cookie is empty.")
    else:
      debug(fmt"cookie: {$cookie}")
    session.deleteAllCookies()
    info("Cookie clear!")
    var cookies = session.getAllCookies()
    debug(fmt"cookies: {$cookies}")

    # element
    var elem = session.findElement(query="h1")
    var elemText = elem.getText()
    debug(fmt"h1 text: {elemText}")

    var elems = session.findElements(query="#ToolList > ul > li a > p > span:first-child > span")
    for e in elems:
      elemText = e.getText()
      debug(fmt"element text: {elemText}")

    # sourceはたくさん出るので封印
    # let source = session.getPageSource()
    # echo source
  except SeleniumWebDriverException as e:
    error("Selenium ERROR!!", e.msg)
    echo e.getStackTrace()
  except Exception as e:
    error("ERROR!!", e.msg)
    echo e.getStackTrace()

main()

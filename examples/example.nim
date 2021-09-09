import logging, strformat, uri, os
import selenimum

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
    var title = session.getTitle()
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
    var elem = session.findElementByTagName("h1")
    var elemText = elem.getText()
    debug(fmt"h1 text: {elemText}")

    var elems = session.findElements(query="#ToolList > ul > li a > p > span:first-child > span")
    for e in elems:
      elemText = e.getText()
      debug(fmt"element text: {elemText}")
    
    # yahoo検索
    elem = session.findElement(query="form input")
    elem.setValue("どんたこす")
    elem = session.findElement(query="form button")
    elem.click()
    sleep(300)
    url = session.getCurrentUrl()
    debug(fmt"URL: {$url}")
    title = session.getTitle()
    debug(fmt"title: {title}")

    elem = session.findElement(query="form input")
    var val = elem.getAttributeValue("value")
    debug(fmt"element value: {val}")
    elem.clearValue()
    elem = session.findElement(query="form button")
    elem.click()
    sleep(300)
    debug(fmt"URL: {$url}")
    title = session.getTitle()
    debug(fmt"title: {title}")

    # クリック
    # elem = session.findElement(query="ニュース", strategy="link text")
    # elemText = elem.getText()
    # debug(fmt"link text: {elemText}")
    # elem.click()
    # sleep(300)
    # url = session.getCurrentUrl()
    # debug(fmt"URL: {$url}")
    # title = session.getTitle()
    # debug(fmt"title: {title}")

    # sourceはたくさん出るので封印
    # let source = session.getPageSource()
    # echo source
  except SeleniumNotFoundException as e:
    error("Not Found Exception!!", e.msg)
    echo e.getStackTrace()
  except SeleniumWebDriverException as e:
    error("Selenium ERROR!!", e.msg)
    echo e.getStackTrace()
  except Exception as e:
    error("ERROR!!", e.msg)
    echo e.getStackTrace()

main()

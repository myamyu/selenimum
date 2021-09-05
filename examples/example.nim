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
    let cookie = session.getNamedCookie("__gads")
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

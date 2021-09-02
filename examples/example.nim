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
    let url = session.getCurrentUrl()
    debug(fmt"URL:{$url}")
  except SeleniumWebDriverException as e:
    error("Selenium ERROR!!", e.getStackTrace())
  except Exception as e:
    error("ERROR!!", e.getStackTrace())

main()

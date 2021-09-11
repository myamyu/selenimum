import logging, strformat, uri, os
import selenimum

const fmtStr = "$date $time - [$levelname] "
addHandler(newConsoleLogger(fmtStr=fmtStr))
addHandler(newRollingFileLogger(filename="examples/logs/example.log", fmtStr=fmtStr))

proc main() =
  info("start the example.")
  defer:
    info("end of example.")

  let
    driver = newSeleniumWebDriver()
    session = driver.newSession()

  info(fmt"sessionID [{session.id}]")

  try:
    info("Navigate to Yahoo!JAPAN ...")
    session.navigateTo("https://www.yahoo.co.jp/")
    var url = session.getCurrentUrl()
    var title = session.getTitle()
    info(&"Page Title:[{title}] URL[{url}]")

    # search web by yahoo japan.
    var elem = session.findElement(query="form input")
    var searchWord = "フィロソフィーのダンス"
    elem.setValue(searchWord)
    elem = session.findElement(query="form button")
    elem.click()
    info(&"searching [{searchWord}] ...")
    sleep(300) # wait for next page.

    # search result
    title = session.getTitle()
    info(&"Page Title: {title}")
    const outputPath = "examples/outputs"
    session.saveScreenshot(&"{outputPath}/searchResults.png")
    var links = session.findElements(query="a.sw-Card__titleInner")
    var urls: seq[string] = @[]
    for i, link in links:
      let linkUrl = link.getAttributeValue("href")
      let h3 = link.findElement(query="h3")
      let linkTitle = h3.getText()
      info(&"No.{i} {linkTitle} {linkUrl}")
      urls.add(linkUrl)

    # take screenshot of result pages
    for i, url in urls:
      info(&"Navigate to [{url}] ...")
      session.navigateTo(url)
      title = session.getTitle()
      info(&"Page Title:[{title}]")
      sleep(1500)
      let pngFile = &"{outputPath}/result-{$i}.png"
      session.saveScreenshot(pngFile)
      info(&"save to [{pngFile}]")

  except SeleniumNotFoundException as e:
    error(&"Not Found Exception!! {e.msg}\n{e.getStackTrace()}")
  except SeleniumWebDriverException as e:
    error(&"Selenium ERROR!! {e.msg}\n{e.getStackTrace()}")
  except Exception as e:
    error(&"ERROR!! {e.msg}\n{e.getStackTrace()}")
  finally:
    info(fmt"delete session [{session.id}]")
    session.deleteSession()

try:
  main()
except Exception as e:
  error(&"ERROR!! {e.msg}\n{e.getStackTrace()}")

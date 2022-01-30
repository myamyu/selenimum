import logging, strformat, uri, os
import selenimum

const fmtStr = "$date $time - [$levelname] "
addHandler(newConsoleLogger(fmtStr = fmtStr))
addHandler(newRollingFileLogger(filename = "examples/logs/example.log", fmtStr = fmtStr))

proc main() =
  info("start the example for macros.")
  defer:
    info("end of example for macros.")

  selenium "http://selenium-hub:4444/wd/hub":
    firefox:
      info("Navigate to Yahoo!JAPAN ...")
      navigateTo "https://www.yahoo.co.jp"
      var url = session.getCurrentUrl()
      var title = session.getTitle()
      info(&"Page Title:[{title}] URL[{url}]")

      var searchWord = "フィロソフィーのダンス"
      setValue "form input", searchWord
      click "form button"

      info(&"searching [{searchWord}] ...")
      sleep(300) # wait for next page.

      title = session.getTitle()
      info(&"Page Title: {title}")
      const outputPath = "examples/outputs"
      screenshot &"{outputPath}/searchResults.png"

      var urls: seq[string] = @[]
      elements "a.sw-Card__titleInner":
        let linkUrl = element.getAttributeValue("href")
        let linkTitle = element.getText("h3")
        info(&"No.{index} {linkTitle} {linkUrl}")
        urls.add(linkUrl)

      # take screenshot of result pages
      for i, url in urls:
        info(&"Navigate to [{url}] ...")
        navigateTo url
        title = session.getTitle()
        info(&"Page Title:[{title}]")
        sleep(1500)
        let pngFile = &"{outputPath}/result-{$i}.png"
        screenshot pngFile
        info(&"save to [{pngFile}]")

try:
  main()
except Exception as e:
  error(&"ERROR!! {e.msg}\n{e.getStackTrace()}")


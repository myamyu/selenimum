## control browser

import json, uri, base64
import session

proc navigateTo*(session: SeleniumSession, url: string) =
  ## Navigate to url by string.
  discard session.post("/url", %*{"url": url})

proc navigateTo*(session: SeleniumSession, url: Uri) =
  ## Navigate to url by Uri.
  discard session.post("/url", %*{"url": $url})

proc getCurrentUrl*(session: SeleniumSession): Uri =
  ## Get current Url.
  let resp = session.get("/url")
  return resp{"value"}.getStr().parseUri()

proc back*(session: SeleniumSession) =
  ## Go back to the previous page.
  discard session.post("/back", %*{})

proc forward*(session: SeleniumSession) =
  ## Go forward to the next page.
  discard session.post("/forward", %*{})

proc refresh*(session: SeleniumSession) =
  ## Refresh current page.
  discard session.post("/refresh", %*{})

proc getTitle*(session: SeleniumSession): string =
  ## Get current page title.
  let resp = session.get("/title")
  return resp{"value"}.getStr()

proc getPageSource*(session: SeleniumSession): string =
  ## Get current page's source.
  let resp = session.get("/source")
  return resp{"value"}.getStr()

proc takeScreenshot*(session: SeleniumSession): string =
  ## Take screenshot of current page.
  ## 
  ## Returns the screenshot as a base64 encoded PNG.
  let resp = session.get("/screenshot")
  return resp{"value"}.getStr()

proc saveScreenshot*(session: SeleniumSession, filePath: string) =
  ## Save screenshot of current page to `filePath`.
  let screenshot = session.takeScreenshot()
  let b = decode(screenshot)
  let f = open(filePath, FileMode.fmWrite)
  defer:
    f.close()
  f.write(b)

## TODO
## ------
## 
## * dismissAlert https://w3c.github.io/webdriver/#dfn-dismiss-alert
## * acceptAlert https://w3c.github.io/webdriver/#dfn-accept-alert
## * getAlertText https://w3c.github.io/webdriver/#dfn-get-alert-text
## * sendAlertText https://w3c.github.io/webdriver/#dfn-send-alert-text
## 

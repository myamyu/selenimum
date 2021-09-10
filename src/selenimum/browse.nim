import json, uri
import session

#[
  navigate to url(by string)
]#
proc navigateTo*(session: SeleniumSession, url: string) =
  discard session.post("/url", %*{"url": url})

#[
  navigate to url(by Uri)
]#
proc navigateTo*(session: SeleniumSession, url: Uri) =
  discard session.post("/url", %*{"url": $url})

#[
  get current Url
]#
proc getCurrentUrl*(session: SeleniumSession): Uri =
  let resp = session.get("/url")
  return resp{"value"}.getStr().parseUri()

#[
  back
]#
proc back*(session: SeleniumSession) =
  discard session.post("/back", %*{})

#[
  forward
]#
proc forward*(session: SeleniumSession) =
  discard session.post("/forward", %*{})


#[
  refresh
]#
proc refresh*(session: SeleniumSession) =
  discard session.post("/refresh", %*{})

#[
  get title
]#
proc getTitle*(session: SeleniumSession): string =
  let resp = session.get("/title")
  return resp{"value"}.getStr()

#[
  get page source
]#
proc getPageSource*(session: SeleniumSession): string =
  let resp = session.get("/source")
  return resp{"value"}.getStr()

#[
  TODO: https://w3c.github.io/webdriver/#dfn-dismiss-alert
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-accept-alert
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-alert-text
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-send-alert-text
]#

#[
  take screenshot of the current page.

  return - The screenshot as a base64 encoded PNG.
]#
proc takeScreenshot*(session: SeleniumSession): string =
  let resp = session.get("/screenshot")
  return resp{"value"}.getStr()

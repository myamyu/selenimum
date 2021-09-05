import json, uri
import session

#[
  navigate to url(by string)
  https://w3c.github.io/webdriver/#dfn-navigate-to
]#
proc navigateTo*(session: SeleniumSession, url: string) =
  discard session.post("/url", %*{"url": url})

#[
  navigate to url(by Uri)
  https://w3c.github.io/webdriver/#dfn-navigate-to
]#
proc navigateTo*(session: SeleniumSession, url: Uri) =
  discard session.post("/url", %*{"url": $url})

#[
  get current Url
  https://w3c.github.io/webdriver/#dfn-get-current-url
]#
proc getCurrentUrl*(session: SeleniumSession): Uri =
  let resp = session.get("/url")
  return resp{"value"}.getStr().parseUri()

#[
  back
  https://w3c.github.io/webdriver/#dfn-back
]#
proc back*(session: SeleniumSession) =
  discard session.post("/back", %*{})

#[
  forward
  https://w3c.github.io/webdriver/#dfn-forward
]#
proc forward*(session: SeleniumSession) =
  discard session.post("/forward", %*{})


#[
  TODO: refresh
  https://w3c.github.io/webdriver/#dfn-refresh
]#

#[
  get title
  https://w3c.github.io/webdriver/#dfn-get-title
]#
proc getTitle*(session: SeleniumSession): string =
  let resp = session.get("/title")
  return resp{"value"}.getStr()

#[
  get page source
  https://w3c.github.io/webdriver/#dfn-get-page-source
]#
proc getPageSource*(session: SeleniumSession): string =
  let resp = session.get("/source")
  return resp{"value"}.getStr()

#[
  TODO: https://w3c.github.io/webdriver/#dfn-perform-actions
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-release-actions
]#

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
  TODO: https://w3c.github.io/webdriver/#dfn-take-screenshot
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-print-page
]#

import json
import session

proc executeScript*(session: SeleniumSession, script: string) =
  ## Execute JavaScript on current page.
  let body = %*{
    "script": script,
    "args": @[],
  }
  discard session.post("/execute/sync", body)

## TODO
## -------
## * executeAsyncScript https://w3c.github.io/webdriver/#dfn-execute-async-script
## 

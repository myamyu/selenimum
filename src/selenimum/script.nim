import json
import session

#[
  execute JavaScript on current page. (sync)
]#
proc executeScript*(session: SeleniumSession, script: string) =
  let body = %*{
    "script": script,
    "args": @[],
  }
  discard session.post("/execute/sync", body)

#[
  execute JavaScript on current page. (async)
  TODO: https://w3c.github.io/webdriver/#dfn-execute-async-script
]#

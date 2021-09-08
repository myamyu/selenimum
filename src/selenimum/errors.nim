import httpclient, json

type
  SeleniumWebDriverException* = object of CatchableError
  SeleniumProtocolException* = object of SeleniumWebDriverException
  SeleniumServerException* = object of SeleniumProtocolException
  SeleniumNotFoundException* = object of SeleniumProtocolException

proc makeErrorMessage(resp: Response): string =
  result = resp.status & "\n"
  let obj = parseJson(resp.body)
  result.add("  error: " & obj{"value", "error"}.getStr() & "\n")
  result.add("  message: " & obj{"value", "message"}.getStr() & "\n")

#[
  check error
]#
proc checkHttpResponse*(resp: Response) =
  if resp.code == Http404:
    let obj = parseJson(resp.body)
    if obj{"value", "error"}.getStr() == "unknown command":
      raise newException(SeleniumServerException, resp.makeErrorMessage())
    raise newException(SeleniumNotFoundException, "")
  if resp.code.is5xx or resp.code.is4xx:
    raise newException(SeleniumServerException, resp.makeErrorMessage())

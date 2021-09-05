import httpclient

type
  SeleniumWebDriverException* = object of CatchableError
  SeleniumProtocolException* = object of SeleniumWebDriverException
  SeleniumServerException* = object of SeleniumProtocolException
  SeleniumNotFoundException* = object of SeleniumProtocolException

proc makeErrorMessage(resp: Response): string =
  result = resp.status & "\n"
  result.add(resp.body)

#[
  check error
]#
proc checkHttpResponse*(resp: Response) =
  if resp.code == Http404:
    raise newException(SeleniumNotFoundException, "")
  if resp.code.is5xx or resp.code.is4xx:
    raise newException(SeleniumServerException, resp.makeErrorMessage())

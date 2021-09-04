type
  SeleniumWebDriverException* = object of CatchableError
  SeleniumProtocolException* = object of SeleniumWebDriverException
  SeleniumServerException* = object of SeleniumProtocolException
  SeleniumNotFoundException* = object of SeleniumProtocolException

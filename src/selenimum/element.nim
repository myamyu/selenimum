import json, strformat
import session

type
  Element* = object
    session: SeleniumSession
    id*: string

proc get*(element:Element, path: string): JsonNode =
  ## Call selenium API GET method for Element.
  ## 
  ## If path = `"/text"` , call `GET /session/{sessionId}/element/{id}/text`.
  return element.session.get(fmt"/element/{element.id}{path}")

proc post*(element:Element, path: string, body: JsonNode): JsonNode =
  ## Call selenium API POST method for Element.
  ## 
  ## If path = `"/click"` , call `POST /session/{sessionId}/element/{id}/click`.
  return element.session.post(fmt"/element/{element.id}{path}", body)

proc findElement*(session: SeleniumSession, query: string, strategy: string = "css selector"): Element =
  ## Find a element by `strategy` (default `"css selector"` ).
  ## 
  ## See https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelement for strategy.
  ## 
  let body = %*{
    "using": strategy,
    "value": query,
  }
  let resp = session.post("/element", body)
  result = Element(session: session)
  for item in resp{"value"}.pairs:
    result.id = item.val.getStr()
    break

proc findElementBySelector*(session: SeleniumSession, query: string): Element =
  ## Find a element by css selector.
  return session.findElement(query=query)

proc findElementById*(session: SeleniumSession, id: string): Element =
  ## Find a element by id attribute.
  return session.findElement(query=fmt"#{id}")

proc findElementByXPath*(session: SeleniumSession, xpath: string): Element =
  ## Find a element by XPath.
  return session.findElement(query=xpath, strategy="xpath")

proc findElementByTagName*(session: SeleniumSession, tagName: string): Element =
  ## Find a element by tag name.
  return session.findElement(query=tagName, strategy="tag name")

proc findElements*(session: SeleniumSession, query: string, strategy: string = "css selector"): seq[Element] =
  ## Find some elements by `strategy` (default `"css selector"` ).
  let body = %*{
    "using": strategy,
    "value": query,
  }
  let resp = session.post("/elements", body)
  result = @[]
  for obj in resp{"value"}:
    for item in obj.pairs:
      result.add(Element(
        session: session,
        id: item.val.getStr()
      ))
      break

proc findElementsBySelector*(session: SeleniumSession, query: string): seq[Element] =
  ## Find some elements by css selector.
  return session.findElements(query=query)

proc findElementsByXPath*(session: SeleniumSession, xpath: string): seq[Element] =
  ## Find some elements by XPath.
  return session.findElements(query=xpath, strategy="xpath")

proc findElementsByTagName*(session: SeleniumSession, tagName: string): seq[Element] =
  ## Find some elements by tag name.
  return session.findElements(query=tagName, strategy="tag name")

proc findElement*(element: Element, query: string, strategy: string = "css selector"): Element =
  ## Find a element from element by `strategy` (default `"css selector"` ).
  let body = %*{
    "using": strategy,
    "value": query,
  }
  let resp = element.post("/element", body)
  result = Element(session: element.session)
  for item in resp{"value"}.pairs:
    result.id = item.val.getStr()
    break

proc findElementBySelector*(element: Element, query: string): Element =
  ## Find a element from element by css selector.
  return element.findElement(query=query)

proc findElementById*(element: Element, id: string): Element =
  ## Find a element from element by id attribute.
  return element.findElement(query=fmt"#{id}")

proc findElementByXPath*(element: Element, xpath: string): Element =
  ## Find a element from element by XPath.
  return element.findElement(query=xpath, strategy="xpath")

proc findElementByTagName*(element: Element, tagName: string): Element =
  ## Find a element from element by tag name.
  return element.findElement(query=tagName, strategy="tag name")

proc findElements*(element: Element, query: string, strategy: string = "css selector"): seq[Element] =
  ## Find some elements from element by `strategy` (default `"css selector"` ).
  let body = %*{
    "using": strategy,
    "value": query,
  }
  let resp = element.post("/elements", body)
  result = @[]
  for obj in resp{"value"}:
    for item in obj.pairs:
      result.add(Element(
        session: element.session,
        id: item.val.getStr()
      ))
      break

proc findElementsBySelector*(element: Element, query: string): seq[Element] =
  ## Find some elements from element by css selector.
  return element.findElements(query=query)

proc findElementsByXPath*(element: Element, xpath: string): seq[Element] =
  ## Find some elements from element by XPath.
  return element.findElements(query=xpath, strategy="xpath")

proc findElementsByTagName*(element: Element, tagName: string): seq[Element] =
  ## Find some elements from element by tag name.
  return element.findElements(query=tagName, strategy="tag name")

proc click*(element: Element) =
  ## Click element.
  discard element.post("/click", %*{})

proc getText*(element: Element): string =
  ## Get element's innner text.
  let resp = element.get("/text")
  return resp{"value"}.getStr()

proc setValue*(element: Element, val: string) =
  ## Set value to `TEXTAREA` or `text INPUT` element.
  ## 
  ## !WARNING! the proc is not working! https://github.com/myamyu/selenimum/issues/22
  let body = %*{
    "text": val,
  }
  discard $element.post("/value", body)

proc getTagName*(element: Element): string =
  ## Get element's tag name.
  let resp = element.get("/name")
  return resp{"value"}.getStr()

proc clearValue*(element: Element) =
  ## Clear `TEXTAREA` or `text INPUT` element's value.
  discard element.post("/clear", %*{})

proc getAttributeValue*(element: Element, name: string): string =
  ## Get value of element's attribute.
  let resp = element.get(fmt"/attribute/{name}")
  return resp{"value"}.getStr()

## TODO
## -------
## 
## * isSelectedElement https://w3c.github.io/webdriver/#dfn-is-element-selected
## * isEnabledElement https://w3c.github.io/webdriver/#dfn-is-element-enabled
## * getElementRect https://w3c.github.io/webdriver/#dfn-get-element-rect
## * getElementCssValue https://w3c.github.io/webdriver/#dfn-get-element-css-value
## 

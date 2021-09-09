import json, strformat
import session

type
  Element* = object
    session: SeleniumSession
    id*: string

# call API GET for Element
proc get*(element:Element, path: string): JsonNode =
  return element.session.get(fmt"/element/{element.id}{path}")

# call API POST for Element
proc post*(element:Element, path: string, body: JsonNode): JsonNode =
  return element.session.post(fmt"/element/{element.id}{path}", body)

#[
  find element
]#
proc findElement*(session: SeleniumSession, query: string, strategy: string = "css selector"): Element =
  let body = %*{
    "using": strategy,
    "value": query,
  }
  let resp = session.post("/element", body)
  result = Element(session: session)
  for item in resp{"value"}.pairs:
    result.id = item.val.getStr()
    break

#[
  find element by css selector
]#
proc findElementBySelector*(session: SeleniumSession, query: string): Element =
  return session.findElement(query=query)

#[
  find element by id attribute
]#
proc findElementById*(session: SeleniumSession, id: string): Element =
  return session.findElement(query=id, strategy="id")

#[
  find element by XPath
]#
proc findElementByXPath*(session: SeleniumSession, xpath: string): Element =
  return session.findElement(query=xpath, strategy="xpath")

#[
  find element by tag name
]#
proc findElementByTagName*(session: SeleniumSession, tagName: string): Element =
  return session.findElement(query=tagName, strategy="tag name")

#[
  find element by name attribute
]#
proc findElementByName*(session: SeleniumSession, name: string): Element =
  return session.findElement(query=name, strategy="name")

#[
  find elements
]#
proc findElements*(session: SeleniumSession, query: string, strategy: string = "css selector"): seq[Element] =
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

#[
  find elements by css selector
]#
proc findElementsBySelector*(session: SeleniumSession, query: string): seq[Element] =
  return session.findElements(query=query)

#[
  find element by XPath
]#
proc findElementsByXPath*(session: SeleniumSession, xpath: string): seq[Element] =
  return session.findElements(query=xpath, strategy="xpath")

#[
  find element by tag name
]#
proc findElementsByTagName*(session: SeleniumSession, tagName: string): seq[Element] =
  return session.findElements(query=tagName, strategy="tag name")

#[
  find element by name attribute
]#
proc findElementsByName*(session: SeleniumSession, name: string): seq[Element] =
  return session.findElements(query=name, strategy="name")

#[
  find element from element
]#
proc findElement*(element: Element, query: string, strategy: string = "css selector"): Element =
  let body = %*{
    "using": strategy,
    "value": query,
  }
  let resp = element.post("/element", body)
  result = Element(session: element.session)
  for item in resp{"value"}.pairs:
    result.id = item.val.getStr()
    break

#[
  find element by css selector
]#
proc findElementBySelector*(element: Element, query: string): Element =
  return element.findElement(query=query)

#[
  find element by id attribute
]#
proc findElementById*(element: Element, id: string): Element =
  return element.findElement(query=id, strategy="id")

#[
  find element by XPath
]#
proc findElementByXPath*(element: Element, xpath: string): Element =
  return element.findElement(query=xpath, strategy="xpath")

#[
  find element by tag name
]#
proc findElementByTagName*(element: Element, tagName: string): Element =
  return element.findElement(query=tagName, strategy="tag name")

#[
  find element by name attribute
]#
proc findElementByName*(element: Element, name: string): Element =
  return element.findElement(query=name, strategy="name")

#[
  find elements from element
]#
proc findElements*(element: Element, query: string, strategy: string = "css selector"): seq[Element] =
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

#[
  find elements by css selector
]#
proc findElementsBySelector*(element: Element, query: string): seq[Element] =
  return element.findElements(query=query)

#[
  find element by XPath
]#
proc findElementsByXPath*(element: Element, xpath: string): seq[Element] =
  return element.findElements(query=xpath, strategy="xpath")

#[
  find element by tag name
]#
proc findElementsByTagName*(element: Element, tagName: string): seq[Element] =
  return element.findElements(query=tagName, strategy="tag name")

#[
  find element by name attribute
]#
proc findElementsByName*(element: Element, name: string): seq[Element] =
  return element.findElements(query=name, strategy="name")

#[
  click element
]#
proc click*(element: Element) =
  discard element.post("/click", %*{})

#[
  get element text
]#
proc getText*(element: Element): string =
  let resp = element.get("/text")
  return resp{"value"}.getStr()

#[
  set input value
]#
proc setValue*(element: Element, val: string) =
  let body = %*{
    "text": val,
  }
  discard element.post("/value", body)

#[
  get element's tag name
]#
proc getTagName*(element: Element): string =
  let resp = element.get("/name")
  return resp{"value"}.getStr()

#[
  clear element value(text INPUT, TEXTAREA)
]#
proc clearValue*(element: Element) =
  discard element.post("/clear", %*{})

#[
  TODO: is selected element(OPTION, checkbox, radio)
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidselected
]#

#[
  TODO: is enabled element
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidenabled
]#

#[
  get value of element's attribute
]#
proc getAttributeValue*(element: Element, name: string): string =
  let resp = element.get(fmt"/attribute/{name}")
  return resp{"value"}.getStr()

#[
  TODO: is displayed element
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementiddisplayed
]#

#[
  TODO: get element location
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidlocation
]#

#[
  TODO: get element location in view
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidlocation_in_view
]#

#[
  TODO: get element size
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidsize
]#

#[
  TODO: get element css property
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidcsspropertyname
]#

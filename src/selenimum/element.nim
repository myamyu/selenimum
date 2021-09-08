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
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelement
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
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelement
]#
proc findElementBySelector*(session: SeleniumSession, query: string): Element =
  return session.findElement(query=query)

#[
  find element by id attribute
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelement
]#
proc findElementById*(session: SeleniumSession, id: string): Element =
  return session.findElement(query=id, strategy="id")

#[
  find element by XPath
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelement
]#
proc findElementByXPath*(session: SeleniumSession, xpath: string): Element =
  return session.findElement(query=xpath, strategy="xpath")

#[
  find element by tag name
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelement
]#
proc findElementByTagName*(session: SeleniumSession, tagName: string): Element =
  return session.findElement(query=tagName, strategy="tag name")

#[
  find element by name attribute
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelement
]#
proc findElementByName*(session: SeleniumSession, name: string): Element =
  return session.findElement(query=name, strategy="name")

#[
  find elements
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelements
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
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelements
]#
proc findElementsBySelector*(session: SeleniumSession, query: string): seq[Element] =
  return session.findElements(query=query)

#[
  find element by XPath
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelements
]#
proc findElementsByXPath*(session: SeleniumSession, xpath: string): seq[Element] =
  return session.findElements(query=xpath, strategy="xpath")

#[
  find element by tag name
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelements
]#
proc findElementsByTagName*(session: SeleniumSession, tagName: string): seq[Element] =
  return session.findElements(query=tagName, strategy="tag name")

#[
  find element by name attribute
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelements
]#
proc findElementsByName*(session: SeleniumSession, name: string): seq[Element] =
  return session.findElements(query=name, strategy="name")

#[
  find element from element
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidelement
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
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidelement
]#
proc findElementBySelector*(element: Element, query: string): Element =
  return element.findElement(query=query)

#[
  find element by id attribute
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidelement
]#
proc findElementById*(element: Element, id: string): Element =
  return element.findElement(query=id, strategy="id")

#[
  find element by XPath
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidelement
]#
proc findElementByXPath*(element: Element, xpath: string): Element =
  return element.findElement(query=xpath, strategy="xpath")

#[
  find element by tag name
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidelement
]#
proc findElementByTagName*(element: Element, tagName: string): Element =
  return element.findElement(query=tagName, strategy="tag name")

#[
  find element by name attribute
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidelement
]#
proc findElementByName*(element: Element, name: string): Element =
  return element.findElement(query=name, strategy="name")

#[
  find elements from element
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidelements
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
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidelements
]#
proc findElementsBySelector*(element: Element, query: string): seq[Element] =
  return element.findElements(query=query)

#[
  find element by XPath
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidelements
]#
proc findElementsByXPath*(element: Element, xpath: string): seq[Element] =
  return element.findElements(query=xpath, strategy="xpath")

#[
  find element by tag name
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidelements
]#
proc findElementsByTagName*(element: Element, tagName: string): seq[Element] =
  return element.findElements(query=tagName, strategy="tag name")

#[
  find element by name attribute
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidelements
]#
proc findElementsByName*(element: Element, name: string): seq[Element] =
  return element.findElements(query=name, strategy="name")

#[
  click element
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidclick
]#
proc click*(element: Element) =
  discard element.post("/click", %*{})


#[
  TODO: submit element
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidsubmit
]#

#[
  get element text
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidtext
]#
proc getText*(element: Element): string =
  let resp = element.get("/text")
  return resp{"value"}.getStr()

#[
  TODO: Send a sequence of key strokes to an element.
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidvalue
]#

#[
  TODO: get element name
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidname
]#

#[
  TODO: clear element value(text INPUT, TEXTAREA)
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidclear
]#

#[
  TODO: is selected element(OPTION, checkbox, radio)
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidselected
]#

#[
  TODO: is enabled element
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidenabled
]#

#[
  TODO: get element attribute
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidattributename
]#

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

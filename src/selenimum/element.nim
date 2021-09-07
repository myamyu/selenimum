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
  TODO: get active element
  https://w3c.github.io/webdriver/#dfn-get-active-element
]#

#[
  TODO: get element shadow root
  https://w3c.github.io/webdriver/#dfn-get-element-shadow-root
]#

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
  TODO: find element from element
  https://w3c.github.io/webdriver/#dfn-find-element-from-element
]#

#[
  TODO: find elements from element
  https://w3c.github.io/webdriver/#dfn-find-elements-from-element
]#

#[
  TODO: find element from shadow root
  https://w3c.github.io/webdriver/#dfn-find-element-from-shadow-root
]#

#[
  TODO: find elements from shadow root
  https://w3c.github.io/webdriver/#dfn-find-elements-from-shadow-root
]#

#[
  TODO: is element selected
  https://w3c.github.io/webdriver/#dfn-is-element-selected
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-element-attribute
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-element-property
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-element-css-value
]#

#[
  get element text
  https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#sessionsessionidelementidtext
]#
proc getText*(element: Element): string =
  let resp = element.get("/text")
  return resp{"value"}.getStr()

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-element-tag-name
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-element-rect
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-is-element-enabled
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-computed-role
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-get-computed-label
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-element-click
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-element-clear
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-element-send-keys
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-take-element-screenshot
]#

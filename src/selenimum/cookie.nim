import json, strformat
import session, errors

type
  Cookie* = object
    domain*: string
    expiry*: int
    httpOnly*: bool
    name*: string
    path*: string
    sameSite*: string
    secure*: bool
    value*: string

#[
  JsonNodeをCookie objectへ
]#
proc convToCookie(obj: JsonNode): Cookie =
  return Cookie(
    domain: obj{"domain"}.getStr(),
    expiry: obj{"expiry"}.getInt(),
    httpOnly: obj{"httpOnly"}.getBool(),
    name: obj{"name"}.getStr(),
    path: obj{"path"}.getStr(),
    sameSite: obj{"sameSite"}.getStr(),
    secure: obj{"secure"}.getBool(),
    value: obj{"value"}.getStr(),
  )

#[
  is empty cookie?
]#
proc isEmpty*(c: Cookie): bool =
  c.name == "" and c.value == ""

#[
  get all cookies
  https://w3c.github.io/webdriver/#dfn-get-all-cookies
]#
proc getAllCookies*(session: SeleniumSession): seq[Cookie] =
  let resp = session.get("/cookie")
  result = @[]
  for obj in resp{"value"}:
    result.add(obj.convToCookie())

#[
  get named cookie
  https://w3c.github.io/webdriver/#dfn-get-named-cookie
]#
proc getNamedCookie*(session: SeleniumSession, name: string): Cookie =
  try:
    let resp = session.get(fmt"/cookie/{name}")
    echo $resp
    return resp{"value"}.convToCookie()
  except SeleniumNotFoundException:
    return Cookie()
  except:
    raise

#[
  TODO: https://w3c.github.io/webdriver/#dfn-adding-a-cookie
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-delete-cookie
]#

#[
  TODO: https://w3c.github.io/webdriver/#dfn-delete-all-cookies
]#

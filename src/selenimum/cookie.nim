import json, strformat
import session, errors

type
  Cookie* = object
    name*: string
    value*: string
    path*: string
    domain*: string
    secure*: bool
    httpOnly*: bool
    expiry*: int
    sameSite*: string

#[
  JsonNodeをCookie objectへ
]#
proc convToCookie(obj: JsonNode): Cookie =
  return Cookie(
    name: obj{"name"}.getStr(),
    value: obj{"value"}.getStr(),
    path: obj{"path"}.getStr(),
    domain: obj{"domain"}.getStr(),
    secure: obj{"secure"}.getBool(),
    httpOnly: obj{"httpOnly"}.getBool(),
    expiry: obj{"expiry"}.getInt(),
    sameSite: obj{"sameSite"}.getStr(),
  )

#[
  cookie to json
]#
proc `%`*(cookie: Cookie): JsonNode =
  result = %*{
    "name": cookie.name,
    "value": cookie.value,
  }
  if cookie.path != "":
    result{"path"} = %cookie.path
  if cookie.domain != "":
    result{"domain"} = %cookie.domain
  if cookie.secure:
    result{"secure"} = %cookie.secure
  if cookie.expiry > 0:
    result{"expiry"} = %cookie.expiry

#[
  is empty cookie?
]#
proc isEmpty*(c: Cookie): bool =
  c.name == "" and c.value == ""

#[
  get all cookies
]#
proc getAllCookies*(session: SeleniumSession): seq[Cookie] =
  let resp = session.get("/cookie")
  result = @[]
  for obj in resp{"value"}:
    result.add(obj.convToCookie())

#[
  get named cookie
]#
proc getNamedCookie*(session: SeleniumSession, name: string): Cookie =
  try:
    let resp = session.get(fmt"/cookie/{name}")
    return resp{"value"}.convToCookie()
  except SeleniumNotFoundException:
    return Cookie()
  except:
    raise

#[
  set cookie
]#
proc setCookie*(session: SeleniumSession, cookie: Cookie) =
  discard session.post("/cookie", %*{
    "cookie": %cookie,
  })

#[
  delete cookie
]#
proc deleteCookie*(session: SeleniumSession, name: string) =
  session.delete(fmt"/cookie/{name}")

#[
  delete all cookies
]#
proc deleteAllCookies*(session: SeleniumSession) =
  session.delete("/cookie")

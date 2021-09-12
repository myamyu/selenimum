## This module is Webdriver for Selenium(Selenium-hub).
## 
## Overview
## ============
## 
## Preparation
## ------------
## 
## Start Selenium-hub before run program.
## 
## If you want to use docker-compse,
## copy `this docker-compose.yaml <https://github.com/myamyu/selenimum/blob/main/docker-compose.yaml>`_ 
## to your working directory and start docker-compose.
## 
## .. code-block::
##  docker-compose up --build
## 
## or
## 
## .. code-block::
##  docker-compose start
## 
## Create session
## ---------------
## 
## Using Chrome. (default)
## 
## .. code-block:: Nim
##  import selenimum
## 
##  proc main() =
##    let
##      driver = newSeleniumWebDriver()
##      session = driver.newSession()
##    defer:
##      session.deleteSession()
##    # ... control Selenium ...
##
##  main()
## 
## Use Firefox.
## 
## Set capabilities(JsonNode) to newSession proc.
## 
## .. code-block:: Nim
##  import selenimum, json
##  
##  proc main() =
##    let
##      driver = newSeleniumWebDriver()
##      capabilities = %*{
##        "desiredCapabilities": {
##          "browserName": "firefox"
##        },
##        "requiredCapabilities": {}
##      }
##      session = driver.newSession(capabilities=capabilities)
##    defer:
##      session.deleteSession()
##    # ... control Selenium ...
##
##  main()
## 
## Navigate to web site
## ---------------------
## 
## .. code-block:: Nim
##  session.navigateTo("https://example.com/") # navigate to example.com
## 
## Find element
## --------------
## 
## .. code-block:: Nim
##  let h1 = session.findElement(query="h1")
##  echo "h1 text:", h1.getText() # h1 text: Example Domain
## 
## Click element
## ---------------
## 
## .. code-block:: Nim
##  let link = session.findElement(query="a")
##  link.click() # move to https://www.iana.org/domains/reserved
##  sleep(300)
##  echo "page title: ", session.getTitle() # page title: IANA — IANA-managed Reserved Domains
## 
## Take screenshot
## ---------------
## 
## .. code-block:: Nim
##  session.saveScreenshot("./example.png")
## 
## Usage
## ---------------
## 
runnableExamples:
  import selenimum, os

  proc main() =
    let
      driver = newSeleniumWebDriver()
      session = driver.newSession()
    defer:
      session.deleteSession()
    
    try:
      session.navigateTo("https://example.com/")
      echo "page title: ", session.getTitle()
      ## Output:
      ##    page title: Example Domain
      let h1 = session.findElement(query="h1")
      echo "h1 text:", h1.getText()
      ## Output:
      ##    h1 text: Example Domain
      session.saveScreenshot("./docs/example.png")
      let link = session.findElement(query="a")
      link.click()
      sleep(300)
      echo "page title: ", session.getTitle()
      ## Output:
      ##    page title: IANA — IANA-managed Reserved Domains
    except Exception as e:
      echo("ERROR!! ", e.msg)
      echo(e.getStackTrace())

  main()

## screenshot
## 
## .. image:: ./example.png
## 

import selenimum/[browse, cookie, element, errors, frame, rect, script, session, webdriver, window]
export browse, cookie, element, errors, frame, rect, script, session, webdriver, window

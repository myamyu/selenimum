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
## Using Firefox.
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
##  let url = "https://example.com/"
##  session.navigateTo(url) # navigate to example.com
## 
## Find element
## --------------
## 
## TODO: write docs.
## 
## Click element
## ---------------
## 
## TODO: write docs.
## 
## Take screenshot
## ---------------
## 
## TODO: write docs.
## 

import selenimum/[browse, cookie, element, errors, frame, rect, script, session, webdriver, window]
export browse, cookie, element, errors, frame, rect, script, session, webdriver, window

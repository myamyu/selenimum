# Package

version       = "0.1.0"
author        = "myamyu"
description   = "WebDriver for Selenium(selenium-hub)."
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.4.8"

# Tasks

task docs, "Generate document":
  exec "nimble doc --index:on --project --out:htmldocs/ src/selenimum.nim"

task examples, "Run example codes":
  exec "nim c --outdir:examples/bin -r examples/example.nim"

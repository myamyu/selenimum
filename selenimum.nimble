# Package

version       = "0.1.0"
author        = "myamyu"
description   = "Selenium web driver"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.4.8"

# Tasks

task docs, "Generate document":
  exec "nimble doc src/selenimum.nim -o:htmldocs/index.html"

task examples, "Run example codes":
  exec "nim c --outdir:examples/bin -r examples/example.nim"

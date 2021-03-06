# Package

version       = "0.2.0"
author        = "myamyu"
description   = "WebDriver for Selenium(selenium-hub)."
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.2.0"

# Tasks

task docs, "Generate document":
  exec "nimble doc --index:on --project --out:htmldocs/ src/selenimum.nim"

task examples, "Run example codes":
  exec "nim c --outdir:examples/bin -r examples/example.nim"

task examples2, "Run example_macros codes":
  exec "nim c --outdir:examples/bin -r examples/example_macros.nim"

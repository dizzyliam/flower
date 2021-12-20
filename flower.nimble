# Package

version       = "0.1.0"
author        = "Liam Scaife"
description   = "A pure Nim bloom filter."
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.0.0"

# Tests
task benchmark, "Runs the benchmark.":
  exec "nim r -d:release -d:danger benchmarks/bm1.nim"

// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Benchmark
import BrainflipKit
import Foundation

@MainActor let benchmarks = {
  let programs = [
    "comprehensive": "",
    "factor": "2346\n",
    //"hanoi": "",
    "numwarp": "(12-345/678.90)",
  ].sorted(by: <)

  for (name, input) in programs {
    Benchmark(name) { benchmark in
      let url = Bundle.module.url(forResource: name, withExtension: "bf")!
      let program = try String(contentsOf: url, encoding: .utf8)
      let interpreter = try Interpreter(program, input: input)

      benchmark.startMeasurement()
      blackHole(try interpreter.run())
    }
  }
}

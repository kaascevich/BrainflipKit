// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Benchmark
import BrainflipKit
import Foundation

let benchmarks = { @Sendable in
  let programs = [
    "comprehensive": "",
    "factor": "2346\n",
    //"hanoi": "",
    "numwarp": "()-./0123456789abcdef",
  ]

  for (name, input) in programs {
    let url = Bundle.module.url(forResource: name, withExtension: "bf")!
    let program = try! String(contentsOf: url, encoding: .utf8)

    Benchmark("Parsing - \(name)") { benchmark in
      _ = try Program(program)
    }

    Benchmark("Execution - \(name)") { benchmark, interpreter in
      _ = try interpreter.run()
    } setup: {
      try Interpreter(program, input: input)
    }
  }
}

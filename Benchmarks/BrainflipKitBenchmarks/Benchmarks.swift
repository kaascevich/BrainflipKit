// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import Benchmark
import BrainflipKit
import Foundation

let benchmarks = { @Sendable in
    let programs = [
        "comprehensive": "",
        "factor": "2346\n",
        "numwarp": "()-./0123456789abcdef",
        "sierpinski": "",
    ]

    unsafe Benchmark.defaultConfiguration.maxDuration = .seconds(3)

    for (name, input) in programs {
        let url = Bundle.module.url(forResource: name, withExtension: "b")!
        guard let program = try? String(contentsOf: url, encoding: .utf8) else {
            fatalError("failed to load program at \(url)")
        }

        Benchmark(
            "Parsing",
            configuration: .init(tags: ["program": name])
        ) { _ in
            blackHole(try Program(program))
        }

        Benchmark(
            "Execution",
            configuration: .init(tags: ["program": name])
        ) { _, program in
            let interpreter = Interpreter(input: input)
            blackHole(interpreter.run(program))
        } setup: {
            try Program(program)
        }

        Benchmark(
            "Combined",
            configuration: .init(tags: ["program": name])
        ) { _ in
            let program = try Program(program)
            let interpreter = Interpreter(input: input)
            blackHole(interpreter.run(program))
        }
    }
}

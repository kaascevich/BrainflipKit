// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import CustomDump
import Testing

@testable import BrainflipKit

extension InterpreterTests {
    @Suite(.timeLimit(.minutes(1))) struct `Program execution` {
        var interpreter = Interpreter()

        @Test func `Basic program`() throws {
            // increments cell 1 and decrements cell 2
            let program = try Program("+>-<")
            let state = interpreter.run(program)

            #expect(state.tape == [0: 1, 1: -1])
            #expect(state.cellPointer == 0)
        }

        @Test func `Simple loops`() throws {
            // sets cell 2 to 9, clears cell 1 in the process
            let program = try Program("+++[>+++<-]")
            let state = interpreter.run(program)

            #expect(state.tape[0] == 0)
            #expect(state.tape[1] == 9)
        }

        @Test func `Nested loops`() throws {
            // sets cell 3 to 27, clears cells 1 and 2 in the process
            let program = try Program("+++[>+++[>+++<-]<-]")
            let state = interpreter.run(program)

            #expect(state.tape[0] == 0)
            #expect(state.tape[1] == 0)
            #expect(state.tape[2] == 27)
        }

        @Test mutating func `Running with input`() throws {
            // outputs the first input character twice, then the
            // third character once
            let program = try Program(",..,,.")
            interpreter = Interpreter(input: "hello")

            let output = interpreter.run(program).output

            #expect(output == "hhl")
        }

        @Test func `'Hello World!' program`() throws {
            let program = try getProgram(named: "helloworld")
            let output = interpreter.run(program).output

            #expect(output == "Hello World!")
        }

        @Test func `Comprehensive test`() throws {
            let program = try getProgram(named: "comprehensive")
            let output = interpreter.run(program).output

            #expect(output == "Hello, world!\n")
        }

        @Test mutating func `Factorization test`() throws {
            let program = try getProgram(named: "factor")
            interpreter = Interpreter(input: "2346\n")
            let output = interpreter.run(program).output

            #expect(output == "2346: 2 3 17 23\n")
        }

        @Test func `Obscure problem tester`() throws {
            let program = try getProgram(named: "obscure")
            let output = interpreter.run(program).output

            #expect(output == "H\n")
        }
    }
}

// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// BrainflipKit is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License (GNU AGPL) as published by
// the Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// BrainflipKit is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with BrainflipKit. If
// not, see <https://www.gnu.org/licenses/>.

extension Interpreter {
  /// Executes the instructions stored in ``Interpreter/program``.
  ///
  /// - Returns: The final state of the interpreter.
  ///
  /// - Throws: An interpreter ``Error`` if an issue was encountered during
  ///   execution.
  public consuming func runReturningFinalState() async throws(InterpreterError) -> State {
    try await execute(program)
    return state
  }

  /// Executes the instructions stored in ``Interpreter/program``.
  ///
  /// - Returns: The program's output.
  ///
  /// - Throws: An interpreter ``Error`` if an issue was encountered during
  ///   execution.
  public consuming func run() async throws(InterpreterError) -> OutputStream {
    try await self.runReturningFinalState().outputStream
  }

  /// Executes the provided instructions.
  ///
  /// - Parameter instructions: The instructions to execute.
  ///
  /// - Throws: An interpreter ``Error`` if an issue was encountered during
  ///   execution.
  mutating func execute(
    _ instructions: [Instruction],
  ) async throws(InterpreterError) {
    for instruction in instructions {
      try await handleInstruction(instruction)
      await Task.yield() // yield to allow other tasks to run
    }
  }

  /// Executes an individual ``Instruction``.
  ///
  /// - Parameter instruction: The instruction to execute.
  ///
  /// - Throws: An interpreter ``Error`` if an issue was encountered during
  ///   execution.
  mutating func handleInstruction(
    _ instruction: Instruction,
  ) async throws(InterpreterError) {
    switch instruction {
    // MARK: Core

    case .add(let count): try handleAddInstruction(count)

    case .move(let count): handleMoveInstruction(count)

    case .loop(let instructions): try await handleLoop(instructions)

    case .output: handleOutputInstruction()
    case .input: try handleInputInstruction()

    // MARK: Non-core

    case .setTo(let value): handleSetToInstruction(value)

    case let .multiply(factor, offset):
      try handleMultiplyInstruction(
        multiplyingBy: factor,
        storingAtOffset: offset
      )

    case .scan(let increment): handleScanInstruction(increment)

    case .extra(let instruction):
      try handleExtraInstruction(instruction)
    }
  }
}

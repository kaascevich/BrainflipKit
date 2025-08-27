// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

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
  public consuming func run() async throws(InterpreterError) -> Output {
    try await runReturningFinalState().outputStream
  }

  /// Executes the provided instructions.
  ///
  /// - Parameter instructions: The instructions to execute.
  ///
  /// - Throws: An interpreter ``Error`` if an issue was encountered during
  ///   execution.
  mutating func execute(
    _ instructions: [Instruction]
  ) async throws(InterpreterError) {
    for instruction in instructions {
      try await handleInstruction(instruction)
      await Task.yield()  // yield to allow other tasks to run
    }
  }

  /// Executes an individual ``Instruction``.
  ///
  /// - Parameter instruction: The instruction to execute.
  ///
  /// - Throws: An interpreter ``Error`` if an issue was encountered during
  ///   execution.
  mutating func handleInstruction(
    _ instruction: Instruction
  ) async throws(InterpreterError) {
    switch instruction {
    // MARK: Core

    case let .add(count): try handleAddInstruction(count)

    case let .move(count): handleMoveInstruction(count)

    case let .loop(instructions): try await handleLoop(instructions)

    case .output: handleOutputInstruction()
    case .input: try handleInputInstruction()

    // MARK: Non-core

    case let .setTo(value): handleSetToInstruction(value)

    case let .multiply(factor, offset):
      try handleMultiplyInstruction(
        multiplyingBy: factor,
        storingAtOffset: offset
      )

    case let .scan(increment): handleScanInstruction(increment)
    }
  }
}

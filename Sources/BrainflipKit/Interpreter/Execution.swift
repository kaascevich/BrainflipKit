// Execution.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

extension Interpreter {
  /// Executes the instructions stored in ``Interpreter/program``.
  ///
  /// - Returns: The final state of the interpreter.
  ///
  /// - Throws: An interpreter ``Error`` if an issue was
  ///   encountered during execution.
  public consuming func runReturningFinalState() async throws(Self.Error) -> State {
    try await execute(program)
    return state
  }
  
  /// Executes the instructions stored in ``Interpreter/program``.
  ///
  /// - Returns: The program's output.
  ///
  /// - Throws: An interpreter ``Error`` if an issue was
  ///   encountered during execution.
  public consuming func run() async throws(Self.Error) -> OutputStream {
    try await self.runReturningFinalState().outputStream
  }

  internal mutating func execute(_ instructions: [Instruction]) async throws(Self.Error) {
    for instruction in instructions {
      try await handleInstruction(instruction)
      await Task.yield()
    }
  }
  
  /// Executes an individual ``Instruction``.
  ///
  /// - Parameter instruction: The instruction to execute.
  ///
  /// - Throws: An interpreter ``Error`` if an issue was
  ///  encountered during execution.
  internal mutating func handleInstruction(
    _ instruction: Instruction
  ) async throws(Self.Error) {
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

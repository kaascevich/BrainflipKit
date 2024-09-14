// Execution.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

extension Interpreter {
  /// Executes the instructions stored in ``Interpreter/program``.
  ///
  /// - Returns: A tuple containing the program's output and
  ///   the final state of the interpreter.
  ///
  /// - Throws: An interpreter ``Error`` if an issue was
  ///   encountered during execution.
  public consuming func runReturningFinalState() async throws -> State {
    for instruction in program {
      try await handleInstruction(instruction)
      await Task.yield()
    }
    
    return state
  }
  
  /// Executes the instructions stored in ``Interpreter/program``.
  ///
  /// - Returns: The program's output.
  ///
  /// - Throws: An interpreter ``Error`` if an issue was
  ///   encountered during execution.
  public consuming func run() async throws -> OutputStream {
    try await self.runReturningFinalState().outputStream
  }
  
  /// Executes an individual ``Instruction``.
  ///
  /// - Parameter instruction: The instruction to execute.
  ///
  /// - Throws: An interpreter ``Error`` if an issue was
  ///  encountered during execution.
  internal mutating func handleInstruction(
    _ instruction: Instruction
  ) async throws {
    switch instruction {
    // MARK: Core
    
    case let .add(count): try handleAddInstruction(count)
      
    case let .move(count): handleMoveInstruction(count)
    
    case let .loop(instructions): try await handleLoop(instructions)
      
    case .output: handleOutputInstruction()
    case .input: try await handleInputInstruction()
      
    // MARK: Non-core
      
    case let .setTo(value): handleSetToInstruction(value)
      
    case let .multiply(factor, offset):
      try handleMultiplyInstruction(
        multiplyingBy: factor,
        storingAtOffset: offset
      )
      
    case let .scan(increment): handleScanInstruction(increment)
      
    case let .extra(instruction):
      try await handleExtraInstruction(instruction)
    }
  }
}

// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

extension Interpreter {
  /// Executes an ``Instruction/input`` instruction.
  ///
  /// - Throws: ``InterpreterError/endOfInput`` if the input iterator is empty
  ///   and ``InterpreterOptions/endOfInputBehavior`` is set to
  ///   ``InterpreterOptions/EndOfInputBehavior/throwError``.
  mutating func handleInputInstruction() throws {
    // make sure we actually have some input to work with
    guard let nextInputScalar = state.inputIterator.next() else {
      switch options.endOfInputBehavior {
      case let .setTo(value): state.currentCellValue = value
      case .throwError: throw InterpreterError.endOfInput
      case nil: break
      }

      return
    }

    state.currentCellValue = CellValue(nextInputScalar.value)
  }
}

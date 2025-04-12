// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// Haven is free software: you can redistribute it and/or modify it under the
// terms of the GNU Affero General Public License (GNU AGPL) as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// Haven is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with Haven. If not, see
// <https://www.gnu.org/licenses/>.

extension Interpreter {
  /// Executes an ``Instruction/add(_:)`` instruction.
  ///
  /// - Parameter value: The value to add to the current cell value.
  ///
  /// - Throws: ``Error/cellOverflow`` or ``Error/cellUnderflow``
  ///   if an overflow/underflow occurs and ``Options/allowCellWraparound``
  ///   is `false`.
  mutating func handleAddInstruction(_ value: Int32) throws(InterpreterError) {
    // depending on the value's sign, we'll use a specific method
    // to update the current cell while checking for wraparound, and
    // we'll also throw a specific error if it occurs
    let (overflowCheck, errorType) = if value < 0 {
      (self.currentCellValue.subtractingReportingOverflow, InterpreterError.cellUnderflow)
    } else {
      (self.currentCellValue.addingReportingOverflow, InterpreterError.cellOverflow)
    }

    // this basically does a C-style cast to the cell type, which
    // is unsigned -- since the only difference between signed and
    // unsigned integers is the way they're interpreted, adding this
    // to an unsigned integer (with overflow) will give the same result
    // as if we added the original value to a signed integer, even if
    // the original value was negative
    let valueAsUnsignedInt = CellValue(bitPattern: value)

    if overflowCheck(valueAsUnsignedInt).overflow {
      guard options.allowCellWraparound else {
        throw errorType(self.cellPointer)
      }
    }

    // the `&+=` operator is similar to `+=`, but it doesn't
    // trap on overflow -- it just lets it happen
    self.currentCellValue &+= valueAsUnsignedInt
  }
}

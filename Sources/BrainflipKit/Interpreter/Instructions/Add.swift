// Add.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

internal extension Interpreter {
  /// Executes an ``Instruction/add(_:)`` instruction.
  /// 
  /// - Parameter value: The value to add to the current cell value.
  /// 
  /// - Throws: ``Error/cellOverflow`` or ``Error/cellUnderflow``
  ///   if an overflow/underflow occurs and ``Options/allowCellWraparound``
  ///   is `false`.
  mutating func handleAddInstruction(_ value: Int32) throws(Self.Error) {
    // depending on the value's sign, we'll use a specific method
    // to update the current cell while checking for wraparound, and
    // we'll also throw a specific error if it occurs
    let (overflowCheck, errorType) = if value < 0 {
      (self.currentCellValue.subtractingReportingOverflow, Error.cellUnderflow)
    } else {
      (self.currentCellValue.addingReportingOverflow, Error.cellOverflow)
    }
    
    // this basically does a C-style cast to the cell type, which
    // is unsigned -- since the only difference between signed and
    // unsigned integers is the way they're interpreted, adding this
    // to an unsigned integer (with overflow) will give the same result
    // as if we added the original value to a signed integer, even if
    // the original value was negative
    let valueAsUnsignedInt = CellValue(bitPattern: value)
    
    // check for wraparound
    if overflowCheck(valueAsUnsignedInt).overflow {
      // check whether it's allowed
      guard options.allowCellWraparound else {
        throw errorType(self.cellPointer)
      }
    }
    
    // the `&+=` operator is similar to `+=`, but it doesn't
    // trap on overflow -- it just lets it happen
    self.currentCellValue &+= valueAsUnsignedInt
  }
}

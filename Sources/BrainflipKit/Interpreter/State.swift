// State.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This package is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This package is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this package. If not, see https://www.gnu.org/licenses/.

public extension Interpreter {
   /// Represents an interpreter's internal state.
   struct State {
      init(
         input: String,
         options: Options
      ) {
         self.inputIterator = input.unicodeScalars.makeIterator()
         
         self.tape = .init(repeating: 0, count: options.tapeSize)
         self.cellPointer = options.initialPointerLocation
      }
      
      /// The array of cells -- also referred to as the *tape*
      /// -- that all Brainflip programs manipulate.
      ///
      /// The tape is 30,000 cells long by default.
      ///
      /// # See Also
      /// - ``Interpreter/State/currentCellValue``
      public internal(set) var tape: [CellValue]
      
      /// Stores the index of the cell currently being used by
      /// the program.
      ///
      /// # See Also
      /// - ``Interpreter/State/currentCellValue``
      public internal(set) var cellPointer: [CellValue].Index
      
      /// An iterator that provides input to a program.
      ///
      /// Each time an ``Instruction/input`` instruction is
      /// executed, the value of this iterator's next Unicode
      /// scalar is stored in the current cell.
      ///
      /// If an `input` instruction is executed, and this
      /// iterator returns `nil`, the current cell will be
      /// set to 0 instead.
      public internal(set) var inputIterator: String.UnicodeScalarView.Iterator
      
      /// The output buffer.
      ///
      /// Each time an ``Instruction/output`` instruction is
      /// executed, the ASCII character corresponding to the
      /// current cell's value is appended to this string.
      public internal(set) var outputBuffer: String = ""
      
      // MARK: Computed State
      
      /// Stores the value of the current cell.
      ///
      /// # See Also
      /// - ``Interpreter/State/cellPointer``
      public internal(set) var currentCellValue: CellValue {
         get { tape[cellPointer] }
         set { tape[cellPointer] = newValue }
      }
   }
   
   /// Resets this interpreter's internal state.
   internal func resetState() {
      state = State(input: originalInput, options: options)
   }
}

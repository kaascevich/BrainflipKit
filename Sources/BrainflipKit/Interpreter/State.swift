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

extension Interpreter {
   /// Represents an interpreter's internal state.
   public struct State {
      // MARK: - Initializers
      
      /// Creates a `State` instance.
      ///
      /// - Parameters:
      ///   - input: The input that will be provided to the
      ///     program.
      ///   - options: Configurable options for this instance.
      internal init(
         input: String,
         options: Options
      ) {
         self.inputIterator = input.unicodeScalars.makeIterator()
         
         self.tape = .init(repeating: 0, count: options.tapeSize)
         self.cellPointer = options.initialPointerLocation
      }
      
      // MARK: - Properties
      
      /// The array of cells -- also referred to as the *tape*
      /// -- that all Brainflip programs manipulate.
      ///
      /// The tape is 30,000 cells long by default.
      ///
      /// # See Also
      /// - ``Interpreter/State/currentCellValue``
      public internal(set) var tape: [CellValue]
      
      /// The index of the cell currently being used by the
      /// program.
      ///
      /// # See Also
      /// - ``Interpreter/State/currentCellValue``
      public internal(set) var cellPointer: [CellValue].Index
      
      /// An iterator that provides input to a program.
      ///
      /// Each time an ``Instruction/input`` instruction is
      /// executed, the value of this iterator's next Unicode
      /// scalar is stored in ``currentCellValue``.
      ///
      /// If an `input` instruction is executed, and this
      /// iterator returns `nil`, `currentCellValue` will be
      /// set to 0 instead.
      ///
      /// # See Also
      /// - ``Instruction/input``
      public internal(set) var inputIterator: String.UnicodeScalarView.Iterator
      
      /// The output buffer.
      ///
      /// Each time an ``Instruction/output`` instruction is
      /// executed, the Unicode scalar corresponding to
      /// ``currentCellValue`` is appended to this string.
      ///
      /// # See Also
      /// - ``Instruction/output``
      public internal(set) var outputBuffer: String = ""
      
      // MARK: - Computed State
      
      /// The value of the current cell.
      ///
      /// This property is equivalent to calling
      /// `tape[cellPointer]`.
      ///
      /// # See Also
      /// - ``Interpreter/State/cellPointer``
      public internal(set) var currentCellValue: CellValue {
         get { tape[cellPointer] }
         set { tape[cellPointer] = newValue }
      }
      
      // MARK: - Extra State
   }
   
   /// Resets this instance's internal state.
   ///
   /// The program to execute, the original input, and this
   /// instance's options will not be reset by this method.
   internal func resetState() {
      state = State(input: originalInput, options: options)
   }
}

// MARK: - Debugging

extension Interpreter.State: CustomDebugStringConvertible {
   /// A textual representation of this instance, suitable
   /// for debugging.
   public var debugDescription: String {
      """
      Tape: \(Array(tape.reversed().drop { $0 == 0 }.reversed()))
      Pointer location: \(cellPointer) (current cell value: \(currentCellValue))
      
      Output: "\(outputBuffer)"
      """
   }
}

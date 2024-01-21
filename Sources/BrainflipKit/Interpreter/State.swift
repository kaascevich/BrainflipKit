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

import OSLog

/// Interprets and executed a Brainflip program.
///
/// # How Brainflip Works
///
/// Brainflip is a very simple programming language, only consisting of
/// eight instructions. However, creating programs in Brainflip can be a
/// challenge like no other due to this reduced instruction set.
///
/// All Brainflip programs mutate an array of *cells* (`UInt8` instances).
/// The array is 30,000 cells long. A pointer (not an actual `UnsafePointer`,
/// just a `CellArray.Index`) is used to keep track of the cell that is
/// currently being mutated.
///
/// Brainflip's instructions are as follows:
///
/// - term ``Instruction/increment``:
///     Increments ``Interpreter/State/currentCellValue`` by 1, wrapping
///     back to 0 if necessary.
///
/// - term ``Instruction/decrement``:
///     Decrements `currentCellValue` by 1, wrapping back to `Cell.max`
///     if necessary.
///
/// - term ``Instruction/nextCell``:
///     Moves ``Interpreter/State/cellPointer`` forward 1 cell.
///
/// - term ``Instruction/prevCell``:
///     Moves `cellPointer` back 1 cell.
///
/// - term ``Instruction/loop(_:)``, with ``Instruction/LoopBound/begin``
///   as the associated value:
///     Starts a loop.
///
/// - term ``Instruction/loop(_:)``, with ``Instruction/LoopBound/end``
///   as the associated value:
///     If `currentCellValue` is 0, does nothing. Otherwise, moves
///     ``Interpreter/State/instructionPointer`` back to the matching
///     `loop(.begin)` instruction.
///
/// - term ``Instruction/output``:
///     Appends the ASCII equivalent of `currentCellValue` to the
///     ``Interpreter/State/output`` buffer.
///     
/// - term ``Instruction/input``:
///     Takes the next character out of the ``Interpreter/State/input``
///     buffer and stores its ASCII value into `currentCellValue`.
///     > Precondition: The next character of input is an ASCII
///     > character.
///
/// All characters other than the ones listed above are treated as
/// comments and ignored.
///
/// # See Also
/// - ``Instruction``
/// - ``run(input:)``
@dynamicMemberLookup public class Interpreter {
   /// The Brainflip program containing a list of instructions
   /// to execute.
   public let program: Program
   
   // MARK: - Internal State
   
   /// The interpreter's internal state.
   private var state: State
   
   /// Represents an interpreter's internal state.
   public struct State {
      private let program: Program
      internal init(program: Program) {
         self.program = program
      }
      
      /// The array of cells that all Brainflip programs manipulate.
      ///
      /// The cell array is 30,000 cells long by default.
      ///
      /// # See Also
      /// - ``Interpreter/State/currentCellValue``
      public internal(set) var cells: CellArray = .init(repeating: 0, count: 30000)
      
      /// Stores the index of the cell currently being used by
      /// the program.
      ///
      /// # See Also
      /// - ``Interpreter/State/currentCellValue``
      public internal(set) var cellPointer: CellArray.Index = 0
      
      /// Stores the index of the current instruction being
      /// executed by the interpreter.
      ///
      /// # See Also
      /// - ``Interpreter/State/currentInstruction``
      /// - ``Interpreter/State/instructionPointerIsValid``
      public internal(set) var instructionPointer: Program.Index = 0
      
      /// Stores the stack, which is used to determine where
      /// to go when looping.
      ///
      /// This stack stores the index of each `loop(.begin)`
      /// instruction that starts a loop containing the
      /// current instruction, outermost to innermost.
      public internal(set) var stack: [Program.Index] = []
      
      /// The input buffer.
      ///
      /// Each time an ``Instruction/input`` instruction is
      /// executed, the ASCII value of the first character in
      /// this string is stored in the current cell, and that
      /// character is removed from the string.
      ///
      /// If an `input` instruction is executed
      /// while this string is empty, the current cell will be
      /// set to 0 instead.
      public internal(set) var input: String = ""
      
      /// The output buffer.
      ///
      /// Each time an ``Instruction/output`` instruction is
      /// executed, the character whose ASCII value equals the
      /// current cell's value is appended to this string.
      public internal(set) var output: String = ""
      
      // MARK: Computed State
      
      /// Stores the value of the current cell.
      ///
      /// # See Also
      /// - ``Interpreter/State/cellPointer``
      public internal(set) var currentCellValue: Cell {
         get { cells[cellPointer] }
         set { cells[cellPointer] = newValue }
      }
      
      /// Stores the current instruction being executed.
      ///
      /// # See Also
      /// - ``Interpreter/State/instructionPointer``
      /// - ``Interpreter/State/instructionPointerIsValid``
      public var currentInstruction: Instruction {
         program[instructionPointer]
      }
      
      /// Stores the number of loops the current instruction
      /// is contained in.
      public var nestingLevel: Int {
         stack.count
      }
      
      // MARK: Error Checking
      
      /// `true` if ``Interpreter/State/instructionPointer``
      /// is a valid index of ``Interpreter/program``;
      /// otherwise, `false`.
      ///
      /// # See Also
      /// - ``Interpreter/State/instructionPointer``
      /// - ``Interpreter/State/currentInstruction``
      public var instructionPointerIsValid: Bool {
         program.indices.contains(instructionPointer)
      }
   }
   
   /// Resets this interpreter's internal state.
   internal func resetState() {
      state = State(program: program)
   }
   
   // MARK: - Dynamic Member Lookup
   
   /// Accesses the interpreter state at the specified key
   /// path.
   ///
   /// Do not call this subscript directly. It is used by the
   /// compiler when you access interpreter state using dot
   /// syntax.
   public subscript<T>(dynamicMember member: KeyPath<State, T>) -> T {
      state[keyPath: member]
   }
   
   /// Accesses and/or mutates the interpreter state at the
   /// specified key path.
   ///
   /// Do not call this subscript directly. It is used by the
   /// compiler when you access or mutate interpreter state
   /// using dot syntax.
   internal subscript<T>(dynamicMember member: WritableKeyPath<State, T>) -> T {
      get { state[keyPath: member] }
      set { state[keyPath: member] = newValue }
   }
   
   // MARK: - Initializers
   
   /// Creates a new `Interpreter` from a ``Program``.
   ///
   /// - Parameter program: A `Program` instance.
   public init(_ program: Program) {
      self.program = program
      self.state = State(program: program)
   }
   
   /// Parses a string into a ``Program`` and creates a
   /// new ``Interpreter`` from it.
   ///
   /// - Parameter string: A string to parse into a `Program`.
   public convenience init(_ string: String) {
      self.init(Program(string))
   }
}

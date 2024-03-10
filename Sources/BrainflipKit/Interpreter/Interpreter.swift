// Interpreter.swift
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

/// Interprets and executes a Brainflip program.
///
/// # How Brainflip Works
///
/// Brainflip is a very simple programming language, only consisting of
/// eight instructions. However, creating programs in Brainflip can be a
/// challenge like no other due to this reduced instruction set.
///
/// All Brainflip programs mutate an array of *cells*, which are 8 bits
/// long by default. A pointer (not an actual `UnsafePointer`, just a
/// `CellArray.Index`) is used to keep track of the cell that is currently
/// being mutated.
///
/// Brainflip's instructions are as follows:
///
/// - term ``Instruction/increment``:
///     Increments ``Interpreter/State/currentCellValue`` by 1, wrapping
///     back to 0 if necessary.
///
/// - term ``Instruction/decrement``:
///     Decrements `currentCellValue` by 1, wrapping back to ``Options/cellMax``
///     if necessary.
///
/// - term ``Instruction/nextCell``:
///     Moves ``Interpreter/State/cellPointer`` forward 1 cell.
///
/// - term ``Instruction/prevCell``:
///     Moves `cellPointer` back 1 cell.
///
/// - term ``Instruction/loop(_:)``:
///     If `currentCellValue` is 0, skips the contained instructions.
///     Otherwise, executes the instructions before repeating the
///     process.
///
/// - term ``Instruction/output``:
///     Appends the character whose Unicode value is `currentCellValue`
///     to the ``Interpreter/State/output`` buffer.
///
/// - term ``Instruction/input``:
///     Takes the next character out of the ``Interpreter/State/input``
///     buffer and stores its Unicode value into  `currentCellValue`.
///     
///     When the `Interpreter` is created, characters whose values are
///     too big to fit in the cell will be removed from the input string.
///
/// All characters other than the ones listed above are treated as
/// comments and ignored.
///
/// # Examples
///
/// ```swift
/// // https://codegolf.stackexchange.com/a/163590/59487
/// let program = ">>>>>+[-->-[>>+>-----<<]<--<---]>-.>>>+.>>..+++[.>]<<<<.+++.------.<<-.>>>>+."
/// let interpreter = try Interpreter(program)
/// let output = try interpreter.run()
/// print(output) // Hello, World!
/// ```
///
/// # See Also
/// - ``Instruction``
/// - ``run()``
public class Interpreter {
   /// The Brainflip program containing a list of instructions
   /// to execute.
   public let program: Program
   
   /// The configurable options for this interpreter.
   public let options: Options
   
   /// The interpreter's internal state.
   internal var state: State
   
   // MARK: - Initializers
   
   /// Creates a new `Interpreter` from a ``Program``.
   ///
   /// - Parameters:
   ///   - program: A `Program` instance.
   ///   - input: The input to pass to the program. Characters
   ///     that are too big to fit in a cell will be removed.
   ///   - options: Configurable options to be used for this
   ///     interpreter.
   public init(
      _ program: Program,
      input: String = "",
      options: Options = .init()
   ) {
      self.program = program
      self.options = options
      
      let trimmedInput = input.filter { $0.unicodeScalars.first!.value < options.cellMax }
      self.state = State(input: trimmedInput, options: options)
   }
   
   /// Parses a string into a ``Program`` and creates a new
   /// `Interpreter` from it.
   ///
   /// - Parameters:
   ///   - string: A string to parse into a `Program`.
   ///   - input: The input to pass to the program. Characters
   ///     that are too big to fit in a cell will be removed.
   ///
   /// - Throws: ``Parser/InvalidProgramError`` if `string` is an
   ///   invalid program.
   public convenience init(
      _ string: String,
      input: String = "",
      options: Options = .init()
   ) throws {
      let program = try Program(string)
      self.init(program, input: input, options: options)
   }
}

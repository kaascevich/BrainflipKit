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

/// Interprets and executes a Brainflip program.
///
/// # How Brainflip Works
///
/// Brainflip is a very simple programming language, only consisting of
/// eight instructions. However, creating programs in Brainflip can be a
/// challenge like no other due to this reduced instruction set.
///
/// All Brainflip programs mutate an array of *cells*. By default, the
/// array is 30,000 cells long. A pointer (not an actual `UnsafePointer`,
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
///     Decrements `currentCellValue` by 1, wrapping back to `CellValue.max`
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
///     Appends `currentCellValue` to the ``Interpreter/State/output``
///     buffer.
///
/// - term ``Instruction/input``:
///     Takes the next UTF-8 code onit out of the
///     ``Interpreter/State/input`` buffer and stores it into
///     `currentCellValue`.
///
/// All characters other than the ones listed above are treated as
/// comments and ignored.
///
/// # Examples
///
/// ```swift
/// // https://codegolf.stackexchange.com/a/163590/59487
/// let program = ">>>>>+[-->-[>>+>-----<<]<--<---]>-.>>>+.>>..+++[.>]<<<<.+++.------.<<-.>>>>+."
/// let interpreter = try Interpreter<UTF8>(program)
/// let output = try interpreter.run()
/// print(output) // Hello, World!
/// ```
///
/// # See Also
/// - ``Instruction``
/// - ``run()``
public class Interpreter<Encoding: Unicode.Encoding> {
   /// The Brainflip program containing a list of instructions
   /// to execute.
   public let program: Program
   
   /// The configurable options for this interpreter.
   public let options: Options
   
   // MARK: - Internal State
   
   /// The interpreter's internal state.
   internal var state: State
   
   /// Represents an interpreter's internal state.
   internal struct State {
      private let program: Program
      fileprivate init(
         program: Program,
         input: [Encoding.CodeUnit],
         options: Options
      ) {
         self.program = program
         self.input = input
         
         self.cells = .init(repeating: 0, count: options.arraySize)
         self.cellPointer = options.initialPointerLocation
      }
      
      /// The array of cells that all Brainflip programs manipulate.
      ///
      /// The cell array is 30,000 cells long by default.
      ///
      /// # See Also
      /// - ``Interpreter/State/currentCellValue``
      var cells: CellArray
      
      /// Stores the index of the cell currently being used by
      /// the program.
      ///
      /// # See Also
      /// - ``Interpreter/State/currentCellValue``
      var cellPointer: CellArray.Index
      
      /// Stores the index of the current instruction being
      /// executed by the interpreter.
      ///
      /// # See Also
      /// - ``Interpreter/State/currentInstruction``
      /// - ``Interpreter/State/instructionPointerIsValid``
      var instructionPointer: Program.Index = 0
      
      /// The input buffer, stored as an `Array` of UTF-8
      /// code units.
      ///
      /// Each time an ``Instruction/input`` instruction is
      /// executed, the first Unicode scalar value in this
      /// array is stored in the current cell, and that
      /// value is removed from the array.
      ///
      /// If an `input` instruction is executed while this
      /// array is empty, the current cell will be set to 0
      /// instead.
      var input: [Encoding.CodeUnit]
      
      /// The output buffer.
      ///
      /// Each time an ``Instruction/output`` instruction is
      /// executed, the current cell's value is appended to
      /// this string as a UTF-8 code unit.
      var output: [Encoding.CodeUnit] = []
      
      // MARK: Computed State
      
      /// Stores the value of the current cell.
      ///
      /// # See Also
      /// - ``Interpreter/State/cellPointer``
      var currentCellValue: CellValue {
         get { cells[cellPointer] }
         set { cells[cellPointer] = newValue }
      }
      
      /// Stores the current instruction being executed.
      ///
      /// # See Also
      /// - ``Interpreter/State/instructionPointer``
      /// - ``Interpreter/State/instructionPointerIsValid``
      var currentInstruction: Instruction {
         program[instructionPointer]
      }
      
      /// Stores the current output string.
      ///
      /// Note that this may not always be valid, depending on
      /// the UTF-8 code units that have been output by the
      /// program.
      var outputString: String {
         String(decoding: output, as: Encoding.self)
      }
      
      // MARK: Error Checking
      
      /// `true` if ``Interpreter/State/instructionPointer``
      /// is a valid index of ``Interpreter/program``;
      /// otherwise, `false`.
      ///
      /// # See Also
      /// - ``Interpreter/State/instructionPointer``
      /// - ``Interpreter/State/currentInstruction``
      var instructionPointerIsValid: Bool {
         program.indices.contains(instructionPointer)
      }
   }
   
   /// Resets this interpreter's internal state.
   internal func resetState() {
      state = State(program: program, input: state.input, options: options)
   }
   
   // MARK: - Initializers
   
   /// Creates a new `Interpreter` from a ``Program``.
   ///
   /// - Parameters:
   ///   - program: A `Program` instance.
   ///   - input: The input to pass to the program. Defaults to
   ///     an empty string.
   ///   - options: Configurable options to be used for this
   ///     interpreter.
   public init(
      _ program: Program,
      input: String = "",
      options: Options = .init()
   ) {
      self.program = program
      self.options = options
      
      var encodedInput: [Encoding.CodeUnit] = []
      _ = transcode(
         input.utf8.makeIterator(),
         from: UTF8.self,
         to: Encoding.self,
         stoppingOnError: false
      ) { encodedInput.append($0) }
      
      self.state = State(program: program, input: Array(encodedInput), options: options)
   }
   
   /// Parses a string into a ``Program`` and creates a new
   /// `Interpreter` from it.
   ///
   /// - Parameters:
   ///   - string: A string to parse into a `Program`.
   ///   - input: The input to pass to the program. Defaults
   ///     to an empty string.
   ///
   /// - Throws: ``Error/invalidProgram`` if `string` is an
   ///   invalid program, or ``Error/illegalCharactersInInput(_:)``
   ///   if `input` contains non-ASCII characters.
   public convenience init(
      _ string: String,
      input: String = "",
      options: Options = .init()
   ) throws {
      guard let program = Program(string) else {
         throw Error.invalidProgram
      }
      self.init(program, input: input, options: options)
   }
}

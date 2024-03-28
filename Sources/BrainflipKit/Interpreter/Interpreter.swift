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
/// long by default. This array is referred to as the *tape*. The tape
/// is infinite in both directions. A *pointer* is used to keep track of
/// the cell that is currently being mutated.
///
/// ## Instruction Set
///
/// ### Core Instructions
///
/// - term ``Instruction/increment``:
///     Increments current cell by 1, wrapping back to 0 if necessary.
///
/// - term ``Instruction/decrement``:
///     Decrements the current cell by 1, wrapping back to
///     `CellValue.max` if necessary.
///
/// - term ``Instruction/moveRight``:
///     Moves the cell pointer forward 1 cell.
///
/// - term ``Instruction/moveLeft``:
///     Moves the cell pointer back 1 cell.
///
/// - term ``Instruction/loop(_:)``:
///     If the current cell is 0, skips the contained instructions.
///     Otherwise, executes the instructions before repeating the
///     process.
///
/// - term ``Instruction/output``:
///     Appends the character whose Unicode value is the current
///     cell's value to the output buffer. If the current cell's
///     value does not correspond to a valid Unicode code point,
///     this instruction does nothing.
///
/// - term ``Instruction/input``:
///     Takes the next character of the input and stores its Unicode
///     value into the current cell.
///
///     If there are no characters remaining in the input, this
///     instruction will do nothing by default (this behavior is
///     configurable).
///
/// ### Optimization Instructions
///
/// These instructions are used internally to optimize programs.
///
/// - term ``Instruction/setTo(_:)``:
///     Sets the current cell to a specific value.
///
/// ### Extra Instructions
///
/// These instructions are disabled by default. They can be enabled
/// via the `options` parameter to an initializer.
///
/// - term ``ExtraInstruction/stop``:
///     Immediately ends the program by throwing a
///     ``Interpreter/Error/stopInstruction`` error.
/// - term ``ExtraInstruction/zero``:
///     Sets the value of the current cell to zero.
/// - term ``ExtraInstruction/bitwiseNot``:
///     Performs a bitwise NOT on the current cell.
/// - term ``ExtraInstruction/leftShift``:
///     Performs a lossy left bit-shift on the current cell.
/// - term ``ExtraInstruction/rightShift``:
///     Performs a lossy right bit-shift on the current cell.
/// - term ``ExtraInstruction/random``:
///     Sets the current cell to a random value.
///
/// All characters other than the ones listed above are treated as
/// comments and ignored.
///
/// # Examples
///
/// ```swift
/// let program = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+."
/// let interpreter = try Interpreter(program)
/// let output = try await interpreter.run()
/// print(output) // Hello World!
/// ```
///
/// # See Also
///
/// - ``Instruction``
/// - ``ExtraInstruction``
/// - ``Program``
///
/// - ``run()``
/// - ``runReturningFinalState()``
///
/// - ``Options``
@dynamicMemberLookup public struct Interpreter: ~Copyable {
   /// The Brainflip program containing a list of instructions
   /// to execute.
   public let program: Program
   
   /// The configurable options for this instance.
   public let options: Options
   
   /// This instance's internal state.
   public private(set) var state: State
   
   // MARK: - Initializers
   
   /// Creates an `Interpreter` instance from the given
   /// `program`.
   ///
   /// - Parameters:
   ///   - program: A ``Program`` instance.
   ///   - input: The input to pass to the program.
   ///   - options: Configurable options to be used for this
   ///     instance.
   ///
   /// - Complexity: O(*n*), where *n* is the length of
   ///   `input.unicodeScalars`.
   public init(
      _ program: Program,
      input: String = "",
      options: Options = .init()
   ) {
      self.program = program
      self.options = options
      self.state = State(input: input, options: options)
   }
   
   /// Parses `string` into a ``Program`` and creates an
   /// `Interpreter` instance from it.
   ///
   /// - Parameters:
   ///   - string: A string to parse into a `Program`.
   ///   - input: The input to pass to the program. Characters
   ///     that are too big to fit in a cell will be removed.
   ///   - options: Configurable options to be used for this
   ///     instance.
   ///
   /// - Throws: An `Error` if `string` cannot be parsed
   ///   into a valid program (that is, if it contains
   ///   unmatched brackets).
   ///
   /// - Complexity: O(*n*), where *n* is the length of
   ///   `input.unicodeScalars`.
   @inlinable public init(
      _ string: String,
      input: String = "",
      options: Options = .init()
   ) throws {
      let program = try Program(string)
      self.init(program, input: input, options: options)
   }
   
   // MARK: - Dynamic Member Lookup
   
   /// Accesses this instance's state at the specified key path.
   ///
   /// Do not call this subscript directly. It is used by the
   /// compiler when you use dot syntax on an `Interpreter`
   /// instance to access properties of its ``State``.
   ///
   /// - Parameter member: A key path to a property of
   ///   `Interpreter.State`.
   ///
   /// - Returns: The value of this instance's state at
   ///   the specified key path.
   public internal(set) subscript<Value>(
      dynamicMember member: WritableKeyPath<State, Value>
   ) -> Value {
      @inlinable get {
         state[keyPath: member]
      }
      @usableFromInline set {
         state[keyPath: member] = newValue
      }
   }
}

// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// BrainflipKit is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License (GNU AGPL) as published by
// the Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// BrainflipKit is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with BrainflipKit. If
// not, see <https://www.gnu.org/licenses/>.

/// Interprets and executes a Brainflip program.
///
/// # How Brainflip Works
///
/// Brainflip is a very simple programming language, only consisting of eight
/// instructions. However, creating programs in Brainflip can be a challenge
/// like no other due to this reduced instruction set.
///
/// All Brainflip programs mutate an array of _cells_, which are 8 bits long by
/// default. This array is referred to as the _tape_. The tape is infinite in
/// both directions. A _pointer_ is used to keep track of the cell that is
/// currently being mutated.
///
/// ## Instruction Set
///
/// ### Core Instructions
///
/// - term ``Instruction/add(_:)``:
///     Increments (or decrements) the current cell by the specified amount,
///     wrapping around if necessary.
///
/// - term ``Instruction/move(_:)``:
///     Moves the cell pointer by the specified amount. If the amount is
///     negative, move the pointer backward.
///
/// - term ``Instruction/loop(_:)``:
///     If the current cell is 0, skips the contained instructions. Otherwise,
///     executes the instructions before repeating the process.
///
/// - term ``Instruction/output``:
///     Writes the character whose Unicode value is the current cell's value to
///     the output stream. If the current cell's value does not correspond to a
///     valid Unicode code point, this instruction does nothing.
///
/// - term ``Instruction/input``:
///     Takes the next character of the input and stores its Unicode value into
///     the current cell.
///
///     If there are no characters remaining in the input, this instruction will
///     do nothing by default (this behavior is configurable).
///
/// ### Optimization Instructions
///
/// These instructions are used internally to optimize programs.
///
/// - term ``Instruction/setTo(_:)``:
///     Sets the current cell to a specific value.
///
/// - term ``Instruction/scan(_:)``:
///     Moves the pointer to the next (or previous) zero cell.
///
/// ### Extra Instructions
///
/// These instructions are disabled by default. They can be enabled via the
/// `options` parameter to an initializer.
///
/// - term ``ExtraInstruction/stop``:
///     Immediately ends the program by throwing a
///     ``Interpreter/Error/stopInstruction`` error.
///
/// - term ``ExtraInstruction/bitwiseNot``:
///     Performs a bitwise NOT on the current cell.
///
/// - term ``ExtraInstruction/leftShift``:
///     Performs a lossy left bit-shift on the current cell.
///
/// - term ``ExtraInstruction/rightShift``:
///     Performs a lossy right bit-shift on the current cell.
///
/// - term ``ExtraInstruction/random``:
///     Sets the current cell to a random value.
///
/// All characters other than the ones listed above are treated as comments and
/// ignored.
///
/// # Examples
///
/// ```swift
/// let program = """
/// ++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>
/// .>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.
/// """
/// let interpreter = try Interpreter(program)
/// let output = try await interpreter.run()
/// print(output) // Hello World!
/// ```
///
/// # See Also
///
/// ## Programs
/// - ``Instruction``
/// - ``ExtraInstruction``
/// - ``Program``
///
/// ## Running
/// - ``run()``
/// - ``runReturningFinalState()``
///
/// ## Options
/// - ``Options``
@dynamicMemberLookup
public struct Interpreter<Input: Sequence<Unicode.Scalar>> {
  /// A Brainflip program containing a list of instructions to execute.
  public let program: Program

  /// The configurable options for this interpreter.
  public let options: InterpreterOptions

  /// This interpreter's internal state.
  public private(set) var state: State

  // MARK: - Initializers

  /// Creates an `Interpreter` instance from the given `program`.
  ///
  /// - Parameters:
  ///   - program: A ``Program`` instance.
  ///   - inputSequence: The input to pass to the program.
  ///   - outputStream: The stream to write outputted characters to.
  ///   - options: Configurable options to be used for this instance.
  public init(
    _ program: Program,
    inputSequence: Input,
    outputStream: OutputStream = "",
    options: InterpreterOptions = .init()
  ) {
    self.program = program
    self.options = options
    self.state = State(
      inputSequence: inputSequence,
      outputStream: outputStream
    )
  }

  /// Parses `source` into a ``Program`` and creates an `Interpreter` instance
  /// from it.
  ///
  /// - Parameters:
  ///   - source: A string to parse into a `Program`.
  ///   - inputSequence: The input to pass to the program.
  ///   - outputStream: The stream to write outputted characters to.
  ///   - options: Configurable options to be used for this instance.
  ///
  /// - Throws: An `Error` if `source` cannot be parsed into a valid program
  ///   (that is, if it contains unmatched brackets).
  @inlinable public init(
    _ source: String,
    inputSequence: Input,
    outputStream: OutputStream = "",
    options: InterpreterOptions = .init()
  ) throws {
    let program = try Program(source)
    self.init(
      program,
      inputSequence: inputSequence,
      outputStream: outputStream,
      options: options
    )
  }

  /// Parses `source` into a ``Program`` and creates an `Interpreter` instance
  /// from it.
  ///
  /// - Parameters:
  ///   - source: A string to parse into a `Program`.
  ///   - input: The input to pass to the program.
  ///   - outputStream: The stream to write outputted characters to.
  ///   - options: Configurable options to be used for this instance.
  ///
  /// - Throws: An `Error` if `source` cannot be parsed into a valid program
  ///   (that is, if it contains unmatched brackets).
  ///
  /// - Complexity: O(_n_), where _n_ is the length of `input.unicodeScalars`.
  public init(
    _ source: String,
    input: String = "",
    outputStream: OutputStream = "",
    options: InterpreterOptions = .init()
  ) throws where Input == String.UnicodeScalarView {
    try self.init(
      source,
      inputSequence: input.unicodeScalars,
      outputStream: outputStream,
      options: options
    )
  }

  // MARK: - Dynamic Member Lookup

  /// Accesses this interpreter's state at the specified key path.
  ///
  /// Do not call this subscript directly. It is used by the compiler when you
  /// use dot syntax on an `Interpreter` instance to access properties of its
  /// ``State``.
  ///
  /// - Parameter member: A key path to a property of `Interpreter.State`.
  ///
  /// - Returns: The value of this interpreter's state at the specified key
  ///   path.
  public internal(set) subscript<Value>(
    dynamicMember member: WritableKeyPath<State, Value>
  ) -> Value {
    @inlinable get { state[keyPath: member] }
    @usableFromInline set { state[keyPath: member] = newValue }
  }
}

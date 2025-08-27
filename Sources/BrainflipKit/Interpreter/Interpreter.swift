// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

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
/// let output = try interpreter.run()
/// print(output) // Hello World!
/// ```
///
/// # See Also
///
/// ## Programs
/// - ``Instruction``
/// - ``Program``
///
/// ## Running
/// - ``run()``
/// - ``runReturningFinalState()``
///
/// ## Options
/// - ``InterpreterOptions``
@dynamicMemberLookup
public struct Interpreter<
  Input: Sequence<Unicode.Scalar>,
  Output: TextOutputStream
> {
  /// A Brainflip program containing a list of instructions to execute.
  public let program: Program

  /// The configurable options for this interpreter.
  public let options: InterpreterOptions

  /// This interpreter's internal state.
  @usableFromInline private(set) var state: State

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
    outputStream: Output = "",
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
    outputStream: Output = "",
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
    outputStream: Output = "",
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

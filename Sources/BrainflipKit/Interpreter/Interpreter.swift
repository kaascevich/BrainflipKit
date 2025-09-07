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
/// All Brainflip programs mutate an array of _cells_. This array is referred to
/// as the _tape_. The tape is infinite in both directions. A _pointer_ is used
/// to keep track of the cell that is currently being mutated.
///
/// ## Instruction Set
///
/// ### Core Instructions
///
/// - term ``Instruction/add(_:)``:
///     Increments (or decrements) the current cell by the specified amount,
///     wrapping around if necessary. (Corresponds to the `+` and `-`
///     characters.)
///
/// - term ``Instruction/move(_:)``:
///     Moves the cell pointer by the specified amount. If the amount is
///     negative, moves the pointer backward. (Corresponds to the `<` and `>`
///     characters.)
///
/// - term ``Instruction/loop(_:)``:
///     If the current cell is 0, skips the contained instructions. Otherwise,
///     executes the instructions before repeating the process. (Corresponds to
///     the `[` and `]` characters.)
///
/// - term ``Instruction/output``:
///     Writes the character whose Unicode value is the current cell's value to
///     the output stream. If the current cell's value does not correspond to a
///     valid Unicode code point, this instruction does nothing. (Corresponds to
///     the `.` character.)
///
/// - term ``Instruction/input``:
///     Takes the next character of the input and stores its Unicode value into
///     the current cell. (Corresponds to the `,` character.)
///
///     If there are no characters remaining in the input, this instruction will
///     do nothing by default (this behavior is configurable).
///
/// ### Optimization Instructions
///
/// These instructions are used internally to optimize programs.
///
/// - term ``Instruction/multiply(_:final:)``:
///     For each offset, adds the value times the current cell value to the cell
///     `offset` cells away from the current cell. Sets the current cell to
///     `final` once completed.
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
/// let interpreter = Interpreter()
/// let output = interpreter.run(program).output
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
/// - ``run(_:)``
///
/// ## Options
/// - ``InterpreterOptions``
public struct Interpreter<
  Input: Sequence<Unicode.Scalar>,
  Output: TextOutputStream
> {
  // MARK: - Properties

  /// The configurable options for this interpreter.
  public let options: InterpreterOptions

  /// This interpreter's internal state.
  var state: State

  // MARK: - Initializers

  /// Creates an `Interpreter` instance.
  ///
  /// - Parameters:
  ///   - input: The input to pass to the program.
  ///   - output: The stream to write outputted characters to.
  ///   - options: Configurable options to be used for this instance.
  public init(
    input: Input,
    output: Output = "",
    options: InterpreterOptions = .init()
  ) {
    self.options = options
    self.state = State(input: input, output: output)
  }

  /// Creates an `Interpreter` instance.
  ///
  /// - Parameters:
  ///   - input: The input to pass to the program.
  ///   - output: The stream to write outputted characters to.
  ///   - options: Configurable options to be used for this instance.
  public init(
    input: String = "",
    output: Output = "",
    options: InterpreterOptions = .init()
  ) where Input == String.UnicodeScalarView {
    self.init(
      input: input.unicodeScalars,
      output: output,
      options: options
    )
  }
}

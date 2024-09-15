// State.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

public extension Interpreter {
  /// Represents an interpreter's internal state.
  struct State {
    // MARK: - Initializers
    
    /// Creates a `State` instance.
    ///
    /// - Parameters:
    ///   - inputIterator: An iterator over the input that will be
    ///     provided to the program.
    ///   - outputStream: The stream to write outputted characters
    ///     to.
    internal init(
      inputIterator: InputIterator,
      outputStream: OutputStream = ""
    ) {
      self.inputIterator = inputIterator
      self.outputStream = outputStream
    }
    
    // MARK: - Properties
    
    /// The array of cells that all Brainflip programs
    /// manipulate.
    ///
    /// # See Also
    /// - ``Interpreter/State/currentCellValue``
    public internal(set) var tape: [Int: CellValue] = [:]
    
    /// The index of the cell currently being used by the
    /// program.
    ///
    /// # See Also
    /// - ``Interpreter/State/currentCellValue``
    public internal(set) var cellPointer: Int = 0
    
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
    public internal(set) var inputIterator: InputIterator
    
    /// The output stream.
    ///
    /// Each time an ``Instruction/output`` instruction is
    /// executed, the Unicode scalar corresponding to
    /// ``currentCellValue`` is written to this stream.
    ///
    /// # See Also
    /// - ``Instruction/output``
    public internal(set) var outputStream: OutputStream
    
    // MARK: - Computed State
    
    /// The value of the current cell.
    ///
    /// This property is equivalent to calling
    /// `tape[cellPointer, default: 0]`.
    ///
    /// # See Also
    /// - ``Interpreter/State/cellPointer``
    public internal(set) var currentCellValue: CellValue {
      @inlinable get { tape[cellPointer, default: 0] }
      @usableFromInline set { tape[cellPointer] = newValue }
    }
  }
}

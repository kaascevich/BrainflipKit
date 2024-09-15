// State.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

extension Interpreter {
  /// Represents an interpreter's internal state.
  public struct State {
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
    /// Most brainf\*\*k interpreters have a fixed-size tape,
    /// but Brainflip's tape is dynamically sized (or, in
    /// layman's terms, infinite). While it _would_ be possible
    /// to implement this using a standard Swift `Array`, it's
    /// not very ergonomic, requiring a whole lot of computed
    /// property shenanigans to abstract away the rather
    /// `fatalError`-y subscript.
    /// 
    /// It's a lot easier to use a `Dictionary` instead, with the
    /// key representing the cell's index (and the value, of course,
    /// representing the value). This also provides the benefits
    /// of being able to use negative indices -- allowing for an
    /// infinite tape in _both_ directions, which _also_ eliminates
    /// the need to handle out-of-bounds errors -- and of using a
    /// whole lot less memory than a standard 30,000-cell `Array`
    /// in the vast majority of use cases.
    /// 
    /// More details on how this works can be found in the
    /// documentation for ``currentCellValue``.
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
    /// As explained in the documentation for ``tape``, using a
    /// `Dictionary` is much more ergonomic than using an `Array`.
    /// This is primarily because `Dictionary` provides a subscript
    /// that returns a default value if the key is not present --
    /// in stark contrast to `Array`, which traps if the index is
    /// out of bounds (albeit for good reason -- most out-of-bounds
    /// accesses are a programmer error). In addition, assigning to
    /// a nonexistent key will simply _create_ the key before
    /// assigning to it.
    /// 
    /// All of this means that the getter and setter for
    /// `currentCellValue` are simple one-liners.
    ///
    /// # See Also
    /// - ``Interpreter/State/tape``
    /// - ``Interpreter/State/cellPointer``
    public internal(set) var currentCellValue: CellValue {
      @inlinable get { tape[cellPointer, default: 0] }
      @usableFromInline set { tape[cellPointer] = newValue }
    }
  }
}

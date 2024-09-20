// Options.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

public extension Interpreter {
  /// Configurable options for an ``Interpreter`` instance.
  struct Options: Sendable {
    /// Whether or not to allow cell overflow and underflow.
    /// Defaults to `true`.
    public let allowCellWraparound: Bool
    
    /// The action to take when an input instruction is
    /// executed with an empty input iterator. Defaults to
    /// doing nothing (`nil`).
    public let endOfInputBehavior: EndOfInputBehavior?
    
    /// Actions to take when an input instruction is
    /// executed with an empty input iterator.
    public enum EndOfInputBehavior: Sendable {
      /// Sets the current cell to a value.
      ///
      /// If the provided value will not fit in a cell, the
      /// cell is instead set to the maximum value that will
      /// fit.
      case setTo(CellValue)
      
      /// Throws an error.
      case throwError
    }
    
    /// Contains extra instructions that an interpreter
    /// should recognize and execute. Defaults to none
    /// (`[]`).
    public let enabledExtraInstructions: Set<ExtraInstruction>
    
    /// Creates an `Options` instance to configure an
    /// ``Interpreter`` with.
    ///
    /// - Parameters:
    ///   - allowCellWraparound: Whether or not to allow
    ///     cell overflow and underflow.
    ///   - endOfInputBehavior: The action to take when an
    ///     input instruction is executed with an empty input
    ///     iterator.
    ///   - enabledExtraInstructions: Extra instructions that
    ///     an interpreter should recognize and execute.
    public init(
      allowCellWraparound: Bool = true,
      endOfInputBehavior: EndOfInputBehavior? = nil,
      enabledExtraInstructions: Set<ExtraInstruction> = []
    ) {
      self.allowCellWraparound = allowCellWraparound
      self.enabledExtraInstructions = enabledExtraInstructions
      self.endOfInputBehavior = endOfInputBehavior
    }
  }
}

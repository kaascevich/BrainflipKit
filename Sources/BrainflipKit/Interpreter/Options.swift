// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

/// Configurable options for an ``Interpreter`` instance.
public struct InterpreterOptions: Sendable {
  /// Whether or not to allow cell overflow and underflow. Defaults to `true`.
  public let allowCellWraparound: Bool

  /// The action to take when an input instruction is executed with an empty
  /// input iterator. Defaults to doing nothing (`nil`).
  public let endOfInputBehavior: EndOfInputBehavior?

  /// Actions to take when an input instruction is executed with an empty
  /// input iterator.
  public enum EndOfInputBehavior: Sendable, BitwiseCopyable {
    /// Sets the current cell to a value.
    ///
    /// If the provided value will not fit in a cell, the cell is instead set
    /// to the maximum value that will fit.
    case setTo(CellValue)

    /// Throws an error.
    case throwError
  }

  /// Creates an `InterpreterOptions` instance to configure an ``Interpreter``
  /// with.
  ///
  /// - Parameters:
  ///   - allowCellWraparound: Whether or not to allow cell overflow and
  ///     underflow.
  ///   - endOfInputBehavior: The action to take when an input instruction is
  ///     executed with an empty input iterator.
  public init(
    allowCellWraparound: Bool = true,
    endOfInputBehavior: EndOfInputBehavior? = nil
  ) {
    self.allowCellWraparound = allowCellWraparound
    self.endOfInputBehavior = endOfInputBehavior
  }
}


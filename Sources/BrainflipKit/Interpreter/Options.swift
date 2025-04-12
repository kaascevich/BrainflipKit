// This file is part of BrainflipKit.
// Copyright © 2024-2025 Kaleb A. Ascevich
//
// Haven is free software: you can redistribute it and/or modify it under the
// terms of the GNU Affero General Public License (GNU AGPL) as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// Haven is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU AGPL for more details.
//
// You should have received a copy of the GNU AGPL along with Haven. If not, see
// <https://www.gnu.org/licenses/>.

public extension Interpreter {
  /// Configurable options for an ``Interpreter`` instance.
  struct Options: Sendable {
    /// Whether or not to allow cell overflow and underflow. Defaults to `true`.
    public let allowCellWraparound: Bool

    /// The action to take when an input instruction is executed with an empty
    /// input iterator. Defaults to doing nothing (`nil`).
    public let endOfInputBehavior: EndOfInputBehavior?

    /// Actions to take when an input instruction is executed with an empty
    /// input iterator.
    public enum EndOfInputBehavior: Sendable {
      /// Sets the current cell to a value.
      ///
      /// If the provided value will not fit in a cell, the cell is instead set
      /// to the maximum value that will fit.
      case setTo(CellValue)

      /// Throws an error.
      case throwError
    }

    /// Contains extra instructions that an interpreter should recognize and
    /// execute. Defaults to none (`[]`).
    public let enabledExtraInstructions: Set<ExtraInstruction>

    /// Creates an `Options` instance to configure an ``Interpreter`` with.
    ///
    /// - Parameters:
    ///   - allowCellWraparound: Whether or not to allow cell overflow and
    ///     underflow.
    ///   - endOfInputBehavior: The action to take when an input instruction is
    ///     executed with an empty input iterator.
    ///   - enabledExtraInstructions: Extra instructions that an interpreter
    ///     should recognize and execute.
    public init(
      allowCellWraparound: Bool = true,
      endOfInputBehavior: EndOfInputBehavior? = nil,
      enabledExtraInstructions: Set<ExtraInstruction> = [],
    ) {
      self.allowCellWraparound = allowCellWraparound
      self.enabledExtraInstructions = enabledExtraInstructions
      self.endOfInputBehavior = endOfInputBehavior
    }
  }
}

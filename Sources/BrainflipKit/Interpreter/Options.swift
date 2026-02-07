// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

/// Configurable options for an ``Interpreter`` instance.
public struct InterpreterOptions: Sendable {
    /// Actions to take when an input instruction is executed with an empty
    /// input iterator.
    public enum EndOfInputBehavior: Sendable {
        /// Sets the current cell to a value.
        ///
        /// If the provided value will not fit in a cell, the cell is instead set
        /// to the maximum value that will fit.
        case setTo(CellValue)

        /// Does nothing.
        case doNothing
    }

    /// The action to take when an input instruction is executed with an empty
    /// input iterator. Defaults to ``EndOfInputBehavior/doNothing``.
    public var endOfInputBehavior: EndOfInputBehavior

    /// Creates an `InterpreterOptions` instance to configure an ``Interpreter``
    /// with.
    ///
    /// - Parameters:
    ///   - endOfInputBehavior: The action to take when an input instruction is
    ///     executed with an empty input iterator.
    public init(endOfInputBehavior: EndOfInputBehavior = .doNothing) {
        self.endOfInputBehavior = endOfInputBehavior
    }
}

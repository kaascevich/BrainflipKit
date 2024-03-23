// Options.swift
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

public extension Interpreter {
   /// Configurable options for an ``Interpreter`` instance.
   struct Options {
      /// The bit size of each cell. Defaults to 8.
      public let cellSize: UInt8
      
      /// Whether or not to allow cell overflow and underflow.
      /// Defaults to `true`.
      public let allowCellWraparound: Bool
      
      /// The action to take when an input instruction is
      /// executed with an empty input buffer. Defaults to
      /// doing nothing (`nil`).
      public let endOfInputBehavior: EndOfInputBehavior?
      
      /// Actions to take when an input instruction is
      /// executed with an empty input buffer.
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
      
      /// Creates an `Options` instance to configure an
      /// ``Interpreter`` with.
      ///
      /// - Parameters:
      ///   - cellSize: The bit size of each cell.
      ///   - allowCellWraparound: Whether or not to allow
      ///     cell overflow and underflow.
      ///   - endOfInputBehavior: The action to take when an
      ///     input instruction is executed with an empty input
      ///     buffer.
      ///
      /// - Precondition: `cellSize` is less than ``maxCellSize``.
      ///
      /// - Note: You *can* set `cellSize` to `0`, and it *will*
      ///   technically work; however, there is no practical
      ///   reason to do this, as it prevents you from changing
      ///   the tape in any way, making the language all but
      ///   useless.
      public init(
         cellSize: UInt8 = 8,
         allowCellWraparound: Bool = true,
         endOfInputBehavior: EndOfInputBehavior? = nil
      ) {
         precondition(
            cellSize < Self.maxCellSize,
            "cellSize is out of bounds (\(cellSize) >= \(Self.maxCellSize)"
         )
         
         self.cellSize = cellSize
         self.allowCellWraparound = allowCellWraparound
         
         self.endOfInputBehavior = switch endOfInputBehavior {
         case .setTo(let value): .setTo(min((1 << cellSize) - 1, value))
         default: endOfInputBehavior
         }
      }
      
      // MARK: - Computed
      
      /// The maximum value allowed in a cell.
      public var cellMax: CellValue {
         (1 << cellSize) - 1
      }
      
      // MARK: - Statics
      
      /// The maximum value permissible for ``cellSize``,
      /// plus 1.
      public static let maxCellSize = CellValue.bitWidth
   }
}

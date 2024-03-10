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
   struct Options {
      /// The bit size of each cell. Defaults to 8.
      public let cellSize: UInt8
      
      /// The size of the array. Defaults to 30,000 cells.
      public let arraySize: CellArray.Index
      
      /// The initial location of the cell pointer. Defaults
      /// to the first cell (index 0).
      public let initialPointerLocation: CellArray.Index
      
      /// Whether or not to allow cell overflow and underflow.
      /// Defaults to `true`.
      public let allowCellWraparound: Bool
      
      /// Creates a new `Options` struct to configure an
      /// ``Interpreter`` with.
      ///
      /// - Parameters:
      ///   - cellSize: The bit size of each cell.
      ///   - arraySize: The size of the array.
      ///   - initialPointerLocation: The initial location
      ///     of the cell pointer.
      ///   - allowCellWraparound: Whether or not to allow
      ///     cell overflow and underflow.
      public init(
         cellSize: UInt8 = 8,
         arraySize: CellArray.Index = 30_000,
         initialPointerLocation: CellArray.Index = 0,
         allowCellWraparound: Bool = true
      ) {
         self.cellSize = cellSize
         self.arraySize = arraySize
         self.initialPointerLocation = initialPointerLocation
         self.allowCellWraparound = allowCellWraparound
      }
      
      // MARK: - Computed
      
      /// The maximum value allowed in a cell.
      public var cellMax: CellValue {
         (1 << cellSize) - 1
      }
   }
}

public extension Interpreter.Options {
   enum EndOfInputBehavior {
      case doNothing
      case setToZero
      case setToMax
   }
}

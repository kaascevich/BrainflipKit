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
      /// The size of the array. Defaults to 30,000 cells.
      internal var arraySize: CellArray.Index
      
      /// The initial location of the cell pointer. Defaults
      /// to the first cell (index 0).
      internal var initialPointerLocation: CellArray.Index
      
      /// Whether or not to allow cell overflow and underflow.
      internal var allowCellWraparound: Bool
      
      public init(
         arraySize: CellArray.Index = 30_000,
         initialPointerLocation: CellArray.Index = 0,
         allowCellWraparound: Bool = true
      ) {
         self.arraySize = arraySize
         self.initialPointerLocation = initialPointerLocation
         self.allowCellWraparound = allowCellWraparound
      }
   }
}

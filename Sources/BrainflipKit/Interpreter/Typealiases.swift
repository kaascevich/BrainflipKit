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

/// The type of a single Brainflip cell.
public typealias CellValue = UInt32

public extension Interpreter {
  /// A type that can be used as an input iterator.
  typealias InputIterator = any IteratorProtocol<Unicode.Scalar>

  /// A type that can be used as an output stream.
  typealias OutputStream = any TextOutputStream
}

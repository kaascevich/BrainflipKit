// Typealiases.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

/// The type of a single Brainflip cell.
public typealias CellValue = UInt32

public extension Interpreter {
  typealias InputIterator = any IteratorProtocol<Unicode.Scalar>
  typealias OutputStream = any TextOutputStream
}

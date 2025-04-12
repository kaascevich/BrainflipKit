// swift-tools-version: 6.1

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

import PackageDescription

/// The package manifest.
let package = Package(
  name: "BrainflipKit",
  platforms: [.macOS(.v13)],
  products: [
    .library(name: "BrainflipKit", targets: ["BrainflipKit"]),
    .executable(name: "brainflip", targets: ["BrainflipCLI"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-algorithms.git",
      from: .init(1, 2, 0)
    ),
    .package(
      url: "https://github.com/apple/swift-argument-parser.git",
      from: .init(1, 5, 0)
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-parsing.git",
      from: .init(0, 13, 0)
    ),
  ],
  targets: [
    .executableTarget(
      name: "BrainflipCLI",
      dependencies: [
        "BrainflipKit",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ]
    ),
    .target(
      name: "BrainflipKit",
      dependencies: [
        .product(name: "Parsing", package: "swift-parsing"),
        .product(name: "Algorithms", package: "swift-algorithms"),
      ]
    ),
    .testTarget(
      name: "BrainflipKitTests",
      dependencies: ["BrainflipKit"]
    ),
  ]
)

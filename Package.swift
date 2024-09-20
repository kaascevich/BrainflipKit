// swift-tools-version: 6.0

// Package.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

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

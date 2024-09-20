// swift-tools-version: 6.0

// Package.swift
// Copyright © 2024 Kaleb A. Ascevich
//
// This project is licensed under the MIT license; see `License.md` in the root
// directory of this repository for more information. If this file is missing,
// the license can also be found at <https://opensource.org/license/mit>.

import PackageDescription

/// Creates a ``Package/Dependency`` from a GitHub repository path.
///
/// - Parameters:
///   - repoPath: A path to a GitHub repository.
///   - version: The version of the dependency to use.
/// 
/// - Returns: A `Dependency` for the given repository.
func dependency(
  fromRepo repoPath: String,
  version: Version
) -> Package.Dependency {
  .package(url: "https://github.com/\(repoPath).git", from: version)
}

/// The package manifest.
let package = Package(
  name: "BrainflipKit",
  platforms: [.macOS(.v13)],
  products: [
    .library(name: "BrainflipKit", targets: ["BrainflipKit"]),
    .executable(name: "brainflip", targets: ["BrainflipCLI"]),
  ],
  dependencies: [
    "apple/swift-algorithms":      .init(1, 2, 0),
    "apple/swift-argument-parser": .init(1, 5, 0),
    "pointfreeco/swift-parsing":   .init(0, 13, 0),
  ].map(dependency),
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

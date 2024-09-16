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
/// - Parameter repoPath: A path to a GitHub repository.
/// 
/// - Returns: A `Dependency` for the given repository.
func dependency(fromRepo repoPath: String) -> Package.Dependency {
  .package(url: "https://github.com/\(repoPath).git", branch: "main")
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
    "apple/swift-algorithms",
    "apple/swift-argument-parser",
    "pointfreeco/swift-parsing",
  ].map(dependency(fromRepo:)),
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

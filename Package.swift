// swift-tools-version: 6.1

// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import PackageDescription

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
      from: "1.2.1"
    ),
    .package(
      url: "https://github.com/apple/swift-argument-parser.git",
      from: "1.6.1"
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-parsing.git",
      from: "0.14.1"
    ),
    .package(
      url: "https://github.com/ordo-one/package-benchmark",
      from: "1.0.0"
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
      dependencies: ["BrainflipKit"],
      resources: [.process("Resources/")]
    ),

    .executableTarget(
      name: "BrainflipKitBenchmarks",
      dependencies: [
        "BrainflipKit",
        .product(name: "Benchmark", package: "package-benchmark"),
        .product(name: "BenchmarkPlugin", package: "package-benchmark"),
      ],
      path: "Benchmarks/BrainflipKitBenchmarks",
      resources: [.process("Resources/")]
    ),
  ]
)

// swift-tools-version: 6.2

// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import PackageDescription

let experimentalFeatures: [SwiftSetting] = [
  "AccessLevelOnImport",
  "AllowUnsafeAttribute",
  "FixedArrays",
  "LifetimeDependence",
  "Lifetimes",
  "Span",
  "SuppressedAssociatedTypes",
  "ValueGenerics",
].map { .enableExperimentalFeature($0) }

let upcomingFeatures: [SwiftSetting] = [
  "ExistentialAny",
  "InternalImportsByDefault",
  "MemberImportVisibility",
  "StrictConcurrency",
].map { .enableUpcomingFeature($0) }

let settings =
  experimentalFeatures + upcomingFeatures + [
    .swiftLanguageMode(.v6),
    .strictMemorySafety(),
  ]

/// The package manifest.
let package = Package(
  name: "BrainflipKit",
  platforms: [.macOS(.v15)],
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
      url: "https://github.com/pointfreeco/swift-custom-dump.git",
      from: "1.3.3"
    ),
    .package(
      url: "https://github.com/ordo-one/package-benchmark.git",
      from: "1.29.4"
    ),
  ],
  targets: [
    .executableTarget(
      name: "BrainflipCLI",
      dependencies: [
        "BrainflipKit",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "CustomDump", package: "swift-custom-dump"),
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
      dependencies: [
        "BrainflipKit",
        .product(name: "CustomDump", package: "swift-custom-dump"),
      ],
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

for target in package.targets {
  target.swiftSettings = (target.swiftSettings ?? []) + settings
}

// swift-tools-version: 6.2

// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import PackageDescription

let upcomingFeatures: [SwiftSetting] = [
    "ExistentialAny",
    "InternalImportsByDefault",
    "MemberImportVisibility",
    "StrictConcurrency",
].map { .enableUpcomingFeature($0) }

let settings =
    upcomingFeatures + [
        .swiftLanguageMode(.v6),
        .strictMemorySafety(),
    ]

/// The package manifest.
let package = Package(
    name: "BrainflipKit",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "BrainflipKit", targets: ["BrainflipKit"]),
        .library(name: "BrainflipTranslation", targets: ["BrainflipTranslation"]),
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
        .package(
            url: "https://github.com/swiftlang/swift-syntax",
            from: "602.0.0"
        ),
        .package(
            url: "https://github.com/SimplyDanny/SwiftLintPlugins",
            from: "0.61.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "BrainflipCLI",
            dependencies: [
                "BrainflipKit",
                "BrainflipTranslation",
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
        .target(
            name: "BrainflipTranslation",
            dependencies: [
                "BrainflipKit",
                .product(name: "SwiftBasicFormat", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
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
        .testTarget(
            name: "BrainflipTranslationTests",
            dependencies: [
                "BrainflipTranslation",
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
    target.plugins =
        (target.plugins ?? []) + [
            .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
        ]
}

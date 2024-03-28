// swift-tools-version: 5.10

// Package.swift
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

import PackageDescription

let swiftLintPlugin = Target.PluginUsage.plugin(name: "SwiftLint", package: "SwiftLintPlugin")
let swiftSettings: [SwiftSetting] = [
   "ConciseMagicFile",
   "ForwardTrailingClosures",
   "StrictConcurrency",
   "ImplicitOpenExistentials",
   "BareSlashRegexLiterals",
   "DeprecateApplicationMain",
   "ImportObjcForwardDeclarations",
   "DisableOutwardActorInference",
   "AccessLevelOnImport",
   "InternalImportsByDefault",
   "IsolatedDefaultValues",
   "GlobalConcurrency",
   "InferSendableFromCaptures",
   "RegionBasedIsolation",
   "ExistentialAny"
].map { .enableExperimentalFeature($0) }

let package = Package(
   name: "BrainflipKit",
   platforms: [
      .macOS(.v13),
      .iOS(.v16),
      .tvOS(.v16),
      .watchOS(.v8),
      .macCatalyst(.v16),
      .visionOS(.v1)
   ],
   products: [
      .library(name: "BrainflipKit", targets: ["BrainflipKit"]),
      .executable(name: "brainflip", targets: ["BrainflipCLI"])
   ],
   dependencies: [
      .package(url: "https://github.com/apple/swift-argument-parser.git", branch: "main"),
      .package(url: "https://github.com/pointfreeco/swift-parsing.git", branch: "main"),
      .package(url: "https://github.com/lukepistrol/SwiftLintPlugin", branch: "main"),
      .package(url: "https://github.com/apple/swift-testing.git", branch: "main")
   ],
   targets: [
      .target(
         name: "BrainflipKit",
         dependencies: [.product(name: "Parsing", package: "swift-parsing")],
         swiftSettings: swiftSettings,
         plugins: [swiftLintPlugin]
      ),
      .executableTarget(
         name: "BrainflipCLI",
         dependencies: [
            "BrainflipKit",
            .product(name: "ArgumentParser", package: "swift-argument-parser")
         ],
         swiftSettings: swiftSettings,
         plugins: [swiftLintPlugin]
      ),
      .testTarget(
         name: "BrainflipKitTests",
         dependencies: [
            "BrainflipKit",
            .product(name: "Testing", package: "swift-testing")
         ],
         swiftSettings: swiftSettings,
         plugins: [swiftLintPlugin]
      )
   ]
)

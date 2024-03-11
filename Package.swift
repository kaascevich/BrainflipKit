// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
let strictConcurrency = SwiftSetting.enableExperimentalFeature("StrictConcurrency")

let package = Package(
   name: "BrainflipKit",
   platforms: [
      .macOS(.v12),
      .iOS(.v15),
      .tvOS(.v15),
      .watchOS(.v7),
      .macCatalyst(.v15),
      .visionOS(.v1)
   ],
   products: [
      // Products define the executables and libraries a package produces, making them visible to other packages.
      .library(name: "BrainflipKit", targets: ["BrainflipKit"]),
      .executable(name: "brainflip", targets: ["BrainflipCLI"])
   ],
   dependencies: [
      .package(url: "https://github.com/Quick/Nimble", branch: "main"),
      .package(url: "https://github.com/apple/swift-argument-parser.git", branch: "main"),
      .package(url: "https://github.com/pointfreeco/swift-parsing.git", branch: "main"),
      .package(url: "https://github.com/lukepistrol/SwiftLintPlugin", branch: "main")
   ],
   targets: [
      // Targets are the basic building blocks of a package, defining a module or a test suite.
      // Targets can depend on other targets in this package and products from dependencies.
      .target(
         name: "BrainflipKit",
         dependencies: [.product(name: "Parsing", package: "swift-parsing")],
         swiftSettings: [strictConcurrency],
         plugins: [swiftLintPlugin]
      ),
      .executableTarget(
         name: "BrainflipCLI",
         dependencies: [
            "BrainflipKit",
            .product(name: "ArgumentParser", package: "swift-argument-parser")
         ],
         swiftSettings: [strictConcurrency],
         plugins: [swiftLintPlugin]
      ),
      .testTarget(
         name: "BrainflipKitTests",
         dependencies: ["BrainflipKit", "Nimble"],
         swiftSettings: [strictConcurrency],
         plugins: [swiftLintPlugin]
      )
   ]
)

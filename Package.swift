// swift-tools-version: 6.0

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

func dependency(fromRepo repoPath: String) -> Package.Dependency {
   .package(url: "https://github.com/\(repoPath).git", branch: "main")
}

let package = Package(
   name: "BrainflipKit",
   platforms: [.macOS(.v15)],
   products: [
      .executable(name: "brainflip", targets: ["BrainflipCLI"])
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
            .product(name: "ArgumentParser", package: "swift-argument-parser")
         ]
      ),
      .target(
         name: "BrainflipKit",
         dependencies: [
            .product(name: "Parsing", package: "swift-parsing"),
            .product(name: "Algorithms", package: "swift-algorithms")
         ]
      ),
      .testTarget(
         name: "BrainflipKitTests",
         dependencies: ["BrainflipKit"]
      )
   ]
)

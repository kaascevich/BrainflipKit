// SPDX-FileCopyrightText: 2025 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

public import BrainflipKit
import SwiftBasicFormat
import SwiftSyntax
import SwiftSyntaxBuilder

public struct SwiftTranslator: Translator {
  var options: InterpreterOptions
  var strictCompatibility: Bool
  public init(options: InterpreterOptions, strictCompatibility: Bool = false) {
    self.options = options
    self.strictCompatibility = strictCompatibility
  }

  public func translate(program: Program) throws -> String {
    let cellType: TypeSyntax = if strictCompatibility { "UInt8" } else { "Int" }

    return try SourceFileSyntax(shebang: "#!/usr/bin/env swift") {
      try ImportDeclSyntax("import Foundation")

      """
      // MARK: Raw Mode
      var currentState = termios()
      _ = unsafe tcgetattr(FileHandle.standardInput.fileDescriptor, &currentState)
      currentState.c_lflag &= ~numericCast(ICANON)
      unsafe withUnsafePointer(to: currentState) {
          _ = unsafe tcsetattr(FileHandle.standardInput.fileDescriptor, TCSAFLUSH, $0)
      }
      """

      """
      // MARK: Declarations
      // give the program a small buffer, in case it goes off the start of the tape
      var array = [\(cellType)](repeating: 0, count: 31_000)
      var pointer: Int = 1_000
      """

      try ioFunctions()

      try translateInstructions(program.instructions)
    }.formatted().description
  }

  private func ioFunctions() throws -> CodeBlockItemListSyntax {
    try .init {
      try FunctionDeclSyntax("func output()") {
        if strictCompatibility {
          // we don't need to unwrap the scalar since `array[pointer]` is
          // a `UInt8`
          """
          try! FileHandle.standardOutput.write(
              contentsOf: String(Unicode.Scalar(array[pointer]))
                  .data(using: .utf8)!
          )
          """
        } else {
          try IfExprSyntax("if let scalar = Unicode.Scalar(array[pointer])") {
            """
            try! FileHandle.standardOutput.write(
                contentsOf: String(scalar).data(using: .utf8)!
            )
            """
          }
        }
      }

      try FunctionDeclSyntax("func input()") {
        try IfExprSyntax(
          "if let character = try? FileHandle.standardInput.read(upToCount: 1)?.first"
        ) {
          "array[pointer] = numericCast(Unicode.Scalar(character).value)"
        } else: {
          switch options.endOfInputBehavior {
          case .setTo(let value):
            "array[pointer] = \(literal: value)"
          case .doNothing:
            "// do nothing"
          }
        }
      }
    }
  }

  private func translateAddInstruction(
    value: CellValue
  ) -> CodeBlockItemListSyntax {
    .init {
      "array[pointer] &+= \(literal: value)"
    }
  }

  private func translateMoveInstruction(
    offset: CellValue
  ) -> CodeBlockItemListSyntax {
    .init {
      "pointer &+= \(literal: offset)"
    }
  }

  private func translateMultiplyInstruction(
    _ multiplications: [CellOffset: CellValue],
    final: CellValue
  ) -> CodeBlockItemListSyntax {
    .init {
      for (offset, value) in multiplications.sorted(by: <) {
        let pointerOffsetExpr: ExprSyntax = "pointer &+ \(literal: offset)"
        "array[\(pointerOffsetExpr)] &+= array[pointer] &* \(literal: value)"
      }
      "array[pointer] = \(literal: final)"
    }
  }

  private func translateOutputInstruction() -> CodeBlockItemListSyntax {
    .init {
      "output()"
    }
  }

  private func translateInputInstruction() -> CodeBlockItemListSyntax {
    .init {
      "input()"
    }
  }

  private func translateLoopInstruction(
    instructions: [Instruction]
  ) throws -> CodeBlockItemListSyntax {
    try .init {
      try WhileStmtSyntax("while array[pointer] != 0") {
        try translateInstructions(instructions)
      }
    }
  }

  private func translateInstructions(
    _ instructions: [Instruction]
  ) throws -> CodeBlockItemListSyntax {
    try .init {
      for instruction in instructions {
        switch instruction {
        case .add(let value):
          translateAddInstruction(value: value)
        case .move(let offset):
          translateMoveInstruction(offset: offset)
        case .loop(let instructions):
          try translateLoopInstruction(instructions: instructions)
        case .output:
          translateOutputInstruction()
        case .input:
          translateInputInstruction()
        case .multiply(let multiplications, let final):
          translateMultiplyInstruction(multiplications, final: final)
        }
      }
    }
  }
}

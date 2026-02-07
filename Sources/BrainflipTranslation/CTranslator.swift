// SPDX-FileCopyrightText: 2025 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

public import BrainflipKit

public struct CTranslator: Translator {
  var options: InterpreterOptions
  var strictCompatibility: Bool
  public init(options: InterpreterOptions, strictCompatibility: Bool = false) {
    self.options = options
    self.strictCompatibility = strictCompatibility
  }

  public func translate(program: Program) -> String {
    let handleEndOfInput =
      switch options.endOfInputBehavior {
      case .setTo(let value):
        "array[pointer] = \(value);"
      case .doNothing:
        ""
      }

    let cellType =
      if strictCompatibility {
        "unsigned char"
      } else {
        "int"
      }

    return """
      #include <stdio.h>
      #include <termios.h>

      // give the program a small buffer, in case it goes off the start of the tape
      \(cellType) array[31000];
      int pointer = 1000;

      void input(void) {
          int character = getchar();
          if (character != EOF) {
              array[pointer] = (\(cellType))character;
          } else {
              \(handleEndOfInput)
          }
      }

      int main(void) {
          // MARK: Raw Mode
          struct termios currentState;
          tcgetattr(0, &currentState);
          currentState.c_lflag &= ~ICANON;
          tcsetattr(0, TCSAFLUSH, &currentState);
      
      \(translateInstructions(program.instructions, indent: "    "))
          return 0;
      }
      """
  }

  private func translateAddInstruction(
    value: CellValue,
    indent: String
  ) -> String {
    indent + "array[pointer] += \(value);"
  }

  private func translateMoveInstruction(
    offset: CellValue,
    indent: String
  ) -> String {
    indent + "pointer += \(offset);"
  }

  private func translateMultiplyInstruction(
    _ multiplications: [CellOffset: CellValue],
    final: CellValue,
    indent: String
  ) -> String {
    let lines =
      multiplications.map { offset, value in
        "array[pointer + \(offset)] += array[pointer] * \(value);"
      } + ["array[pointer] = \(final);"]

    return lines.map { indent + $0 }.joined(separator: "\n")
  }

  private func translateOutputInstruction(indent: String) -> String {
    indent + "putchar((int)array[pointer]);"
  }

  private func translateInputInstruction(indent: String) -> String {
    indent + "input();"
  }

  private func translateLoopInstruction(
    instructions: [Instruction],
    indent: String
  ) -> String {
    """
    \(indent)while (array[pointer] != 0) {
    \(translateInstructions(instructions, indent: indent + "    "))
    \(indent)}
    """
  }

  private func translateInstructions(
    _ instructions: [Instruction],
    indent: String
  ) -> String {
    instructions.map { instruction in
      switch instruction {
      case .add(let value):
        translateAddInstruction(value: value, indent: indent)
      case .move(let offset):
        translateMoveInstruction(offset: offset, indent: indent)
      case .loop(let instructions):
        translateLoopInstruction(instructions: instructions, indent: indent)
      case .output:
        translateOutputInstruction(indent: indent)
      case .input:
        translateInputInstruction(indent: indent)
      case .multiply(let multiplications, let final):
        translateMultiplyInstruction(
          multiplications,
          final: final,
          indent: indent
        )
      }
    }.joined(separator: "\n")
  }
}

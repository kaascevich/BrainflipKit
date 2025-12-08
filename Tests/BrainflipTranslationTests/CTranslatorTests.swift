// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import BrainflipKit
import CustomDump
import Testing

@testable import BrainflipTranslation

@Suite struct CTranslatorTests {
  @Test func `Simple translation`() throws {
    let program = try getProgram(named: "simple")
    let translator = CTranslator(options: .init())
    let translated = translator.translate(program: program)
    expectNoDifference(
      translated,
      """
      #include <stdio.h>
      
      // give the program a small buffer, in case it goes off the start of the tape
      int array[31000];
      int pointer = 1000;
      
      void input(void) {
          int character = getchar();
          if (character >= 0) {
              array[pointer] = (int)character;
          } else {
              
          }
      }
      
      int main(void) {
          input();
          while (array[pointer] != 0) {
              pointer += 1;
              array[pointer] += 1;
              pointer -= 1;
              array[pointer] -= 1;
              putchar((int)array[pointer]);
          }
          return 0;
      }
      """
    )
  }

  @Test func `Simple translation with strict compatibility`() throws {
    let program = try getProgram(named: "simple")
    let translator = CTranslator(options: .init())
    let translated = translator.translate(
      program: program,
      strictCompatibility: true
    )
    expectNoDifference(
      translated,
      """
      #include <stdio.h>
      
      // give the program a small buffer, in case it goes off the start of the tape
      unsigned char array[31000];
      int pointer = 1000;
      
      void input(void) {
          int character = getchar();
          if (character >= 0) {
              array[pointer] = (unsigned char)character;
          } else {
              
          }
      }
      
      int main(void) {
          input();
          while (array[pointer] != 0) {
              pointer += 1;
              array[pointer] += 1;
              pointer -= 1;
              array[pointer] -= 1;
              putchar((int)array[pointer]);
          }
          return 0;
      }
      """
    )
  }
}

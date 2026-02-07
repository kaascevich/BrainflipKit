// SPDX-FileCopyrightText: 2024 Kaleb A. Ascevich
// SPDX-License-Identifier: AGPL-3.0-or-later

import ArgumentParser
import BrainflipKit
import BrainflipTranslation
import Foundation

extension Brainflip {
    struct Translate: AsyncParsableCommand {
        // MARK: - Command Configuration

        static let configuration = CommandConfiguration(
            abstract: "Translates a brainfuck program into another language."
        )

        // MARK: - Options

        enum Language: String, CaseIterable, ExpressibleByArgument {
            case swift
            case c

            var translatorType: any Translator.Type {
                switch self {
                    case .swift: SwiftTranslator.self
                    case .c: CTranslator.self
                }
            }
        }

        @Option(name: .shortAndLong, help: "The language to translate to.")
        var language: Language

        @Flag(
            name: [.long, .customShort("c")],
            help: "Whether to enable strict compatibility."
        )
        var strictCompatibility: Bool = false

        // MARK: - Option Groups

        @OptionGroup(title: "Program Options")
        var programOptions: ProgramOptionGroup

        @OptionGroup(title: "Interpreter Options")
        var interpreterOptions: InterpreterOptionGroup

        // MARK: - Implementation

        func run() async throws {
            let parsedProgram = try programOptions.parseProgram()

            let translator = language.translatorType.init(
                options: interpreterOptions.makeInterpreterOptions(),
                strictCompatibility: strictCompatibility
            )
            print(try await translator.translate(program: parsedProgram))
        }
    }
}

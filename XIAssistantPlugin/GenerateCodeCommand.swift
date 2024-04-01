//
//  GenerateCodeCommand.swift
//  Plugin
//
//  Created by Morisson Marcel on 30/03/24.
//

import Foundation
import XcodeKit

class GenerateCodeCommand: NSObject, XCSourceEditorCommand {
    
    /// Parses the provided prompt to extract the code that needs to be generated.
    /// - Parameter selection: The selected lines of code.
    /// - Returns: The code that needs to be generated.
    func parsePrompt(_ selection: String) -> String {
        let regex = try! NSRegularExpression(pattern: "\\*/|//.*", options: .anchorsMatchLines)
        let matches = regex.matches(in: selection,
                                    range: NSRange(location: 0, length: selection.count))
        var instructions: [String] = []
        var sampleCode = selection
        
        for match in matches {
            let range = Range(match.range, in: selection)!
            let raw = selection[range]
            let text = raw
                .replacingOccurrences(of: "//", with: "")
                .trimmingCharacters(in: .whitespaces)
            guard text.hasPrefix("@IA") else { continue }
            instructions.append(text.replacingOccurrences(of: "@IA", with: ""))
            sampleCode = sampleCode.replacingOccurrences(of: raw, with: "")
        }
        
        sampleCode = sampleCode.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return [
            !sampleCode.isEmpty ? "Using the following code: \(sampleCode)" : "",
            instructions.map{ "Problem: \($0)" }.joined(separator: "\n")
        ].joined(separator: "\n")
    }
    
    /// Performs the generation of code based on the provided prompt.
    /// - Parameters:
    ///   - invocation: The source editor command invocation.
    ///   - completionHandler: The completion handler to call when the command is finished.
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        let intentLines = invocation.selectedLines ?? invocation.allLines
        let intent = parsePrompt(intentLines.joined(separator: "\n"))
        
        Task {
            let provider = SourceEditorExtension.shared?.provider
            guard let documented = try? await provider?.invoke(for: .generation(intent)) else {
                completionHandler(nil)
                return
            }
            invocation.replaceSelection(with: documented)
            completionHandler(nil)
        }
    }
}

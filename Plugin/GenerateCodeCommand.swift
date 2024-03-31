//
//  GenerateCodeCommand.swift
//  Plugin
//
//  Created by Morisson Marcel on 30/03/24.
//

import Foundation
import XcodeKit

class GenerateCodeCommand: NSObject, XCSourceEditorCommand {
    
    func parsePrompt(_ selection: String) -> String {
        let regex = try! NSRegularExpression(pattern: "\\*/|//.*", options: .anchorsMatchLines)
        let matches = regex.matches(in: selection, range: NSRange(location: 0, length: selection.utf16.count))
        var code = ""
        for match in matches {
            let range = Range(match.range, in: selection)!
            code += String(selection[range])
        }
        return code
    }
    
    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void ) -> Void {        
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

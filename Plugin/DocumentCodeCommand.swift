//
//  DocumentCodeCommand.swift
//  Plugin
//
//  Created by Morisson Marcel on 28/03/24.
//

import Foundation
import XcodeKit

class DocumentCodeCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void ) -> Void {
        let codeLines = invocation.selectedLines ?? invocation.allLines
        let intent = codeLines.joined(separator: "\n")
        
        Task {
            let provider = SourceEditorExtension.shared?.provider
            
            guard let documented = try? await provider?.invoke(for: .documentation(intent)) else {
                completionHandler(nil)
                return
            }
            
            invocation.replaceSelection(with: documented, relevantTag: "DOC")
            completionHandler(nil)
        }
    }
    
}

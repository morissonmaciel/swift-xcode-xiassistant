//
//  DocumentCodeCommand.swift
//  Plugin
//
//  Created by Morisson Marcel on 28/03/24.
//

import Foundation
import XcodeKit

class DocumentCodeCommand: NSObject, XCSourceEditorCommand {
    /// Performs the command with the provided invocation.
    /// - Parameters:
    ///   - invocation: The invocation of the command.
    ///   - completionHandler: The completion handler to call when the command is finished.
    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void) -> Void {
        let codeLines = invocation.selectedLines ?? invocation.allLines
        /// The intent of the code to be documented.
        let intent = codeLines.joined(separator: "\n")
        Task {
            /// The provider for the documentation command.
            let provider = SourceEditorExtension.shared?.provider
            /// The documented code.
            guard let documented = try? await provider?.invoke(for: .documentation(intent)) else {
                completionHandler(nil)
                return
            }
            /// Replaces the selection with the documented code.
            invocation.replaceSelection(with: documented, relevantTag: "DOC")
            /// Calls the completion handler to indicate that the command is finished.
            completionHandler(nil)
        }
    }
}

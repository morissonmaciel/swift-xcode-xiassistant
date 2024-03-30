//
//  DocumentSelectedCodeCommand.swift
//  Plugin
//
//  Created by Morisson Marcel on 28/03/24.
//

import Foundation
import XcodeKit

class DocumentSelectedCodeCommand: NSObject, XCSourceEditorCommand {
    
    func consultAssistantAPI(with prompt: String) async throws -> CodeSelection {
        let url = URL(string: "http://localhost:3000/api/assistant/doc")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonData = try JSONSerialization.data(withJSONObject: [
            "code": prompt
        ])
        request.httpBody = jsonData
        
        var streamlined = CodeSelection()
        let (bytes, _) = try await URLSession.shared.bytes(for: request)
        
        for try await line in bytes.lines {
            streamlined.append(line)
        }
        
        return streamlined
    }
    
    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void ) -> Void {
        guard let lines = invocation.buffer.lines as? [String],
              let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(nil)
            return
        }
        
        let start = selection.start.line
        let end = selection.end.line > (lines.count - 1) ? lines.count - 1 : selection.end.line
        let count = end - start
        
        let selectedRange = lines[start...end]
        let code = selectedRange.joined()
        
        Task {
            guard let documented = try? await consultAssistantAPI(with: code) else {
                completionHandler(nil)
                return
            }
            
            invocation.buffer.lines.removeObjects(at: IndexSet(start...end))
            
            var index = 0
            
            for text in documented {
                guard text.prefix(3) != "```" else { continue }
                invocation.buffer.lines.insert(text, at: start + index)
                index += 1
            }
            
            invocation.buffer.lines.insert("", at: start + index)
            
            completionHandler(nil)
        }
    }
    
}

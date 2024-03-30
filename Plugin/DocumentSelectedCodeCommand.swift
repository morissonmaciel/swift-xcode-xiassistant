//
//  DocumentSelectedCodeCommand'.swift
//  Plugin
//
//  Created by Morisson Marcel on 28/03/24.
//

import Foundation
import XcodeKit

class DocumentSelectedCodeCommand: NSObject, XCSourceEditorCommand {
    
    typealias Selection = [String]
    
    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void ) -> Void {
        guard let lines = invocation.buffer.lines as? [String],
              let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(nil)
            return
        }
        
        let selectedRange = lines.getRanges(textRange: selection)
        var unformatted = Selection()
        
        for (index, r) in selectedRange.enumerated() {
            let line = lines[selection.start.line + index]
            let selected = line[r]
            unformatted.append(String(selected))
            
            invocation.buffer.lines[selection.start.line + index] = "// \(String(selected))"
        }
        
        print(unformatted)
        completionHandler(nil)
    }
    
}

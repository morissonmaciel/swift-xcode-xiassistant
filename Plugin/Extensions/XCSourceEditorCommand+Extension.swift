//
//  XCSourceEditorCommand+Extension.swift
//  Plugin
//
//  Created by Morisson Marcel on 31/03/24.
//

import Foundation
import XcodeKit

extension XCSourceEditorCommandInvocation {
    
    /// Returns the selected lines of code in the current buffer, or an empty array if no selection is made.
    var selectedLines: CodeSelection? {
        guard let lines = self.buffer.lines as? [String],
              let selection = self.buffer.selections.firstObject as? XCSourceTextRange else {
            return nil
        }
        
        let start = selection.start.line
        let end = selection.end.line > (lines.count - 1) ? lines.count - 1 : selection.end.line
        
        let selectedRange = lines[start...end]
        return CodeSelection(selectedRange)
    }
    
    /// Returns all the lines of code in the current buffer.
    var allLines: CodeSelection {
        guard let lines = self.buffer.lines as? [String] else {
            return []
        }
        
        return lines as CodeSelection
    }
    
    /// Replaces the selected lines of code with new lines of code, preserving any existing code blocks or comments.
    func replaceSelection(with newLines: [String], relevantTag: String = "CODE", strictToCode: Bool = true) {
        guard let selection = self.buffer.selections.firstObject as? XCSourceTextRange else { return }
        
        let start = selection.start.line
        let end = selection.end.line
        
        var index = start
        var isCodeBlock = false
        
        for newLine in newLines {
            var ignoreLine = false
            
            if newLine.hasPrefix("[\(relevantTag)]") {
                isCodeBlock = true
                ignoreLine = true
            }
            
            if newLine.hasPrefix("[/\(relevantTag)]") {
                isCodeBlock = false
                ignoreLine = true
            }
            
            guard !ignoreLine  else { continue }
            if !isCodeBlock && strictToCode { continue }
            
            let newEntry = isCodeBlock ? newLine : "// \(newLine)"
            
            if index > end {
                self.buffer.lines.insert(newEntry, at: index)
            } else {
                self.buffer.lines[index] = newEntry
            }
            
            index += 1
        }
    }
}

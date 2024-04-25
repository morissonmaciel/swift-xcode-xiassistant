//
//  CodeDocumentationViewModel.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 22/04/24.
//

import Foundation
import Observation
import MarkdownUI
import SwiftSoup

/**
 CodeDocumentationViewModel: A view model responsible for extracting code from HTML strings.
 */
@Observable final class CodeDocumentationViewModel {
    /**
     The current code snippet being processed.

     - Note: This property is used to store the extracted code.
     */
    var currentCode: String = ""

    /**
     Extracts text inside `<code>` tags from an HTML string.

     - Parameters:
       - htmlString: The input HTML string containing code snippets.

     - Returns: The extracted code as a string. If no code is found, returns the original HTML string.
     */
    func extractTextInsideCodeTags(from htmlString: String) throws -> String {
        let dom = try SwiftSoup.parse(htmlString)
        let codeTags = try dom.getElementsByTag("code")
        return try codeTags.first()?.text() ?? htmlString
    }

    /**
     Invokes the OllamaProvider to generate documentation for the current code snippet.

     - Returns: The generated documentation as a string.
     */
    func invoke() async throws {
        let provider = OllamaProvider()
        let results = try await provider.invoke(for: .documentation(currentCode))
        currentCode = try extractTextInsideCodeTags(from: MarkdownContent(results.joined(separator: "\n")).renderHTML())
    }
}

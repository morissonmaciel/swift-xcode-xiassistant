//
//  OllamaProvider.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 22/04/24.
//

import Foundation
import OpenAI

class OllamaProvider {
    private let settings = OllamaIntegrationSettings.shared
    private let baseSystem = """
    Act as a staff iOS engineer, specializing in UIKit, SwiftUI, SwiftData, CoreData, DocC syntax, markdown documentation, prototyping and unit testing.
    Be capable of creating code from provided prompt, and able to document code using Xcode DocC conventions.
    """
    
    enum APIIntent {
        case documentation(String)
        case generation(String)
    }
    
    func invoke(for intent: APIIntent) async throws -> [String] {
        let apiKey = settings.apiKey
        let temperature = settings.temperature
        let model = settings.model
        guard let remoteUrl = URL(string: settings.remoteUrl) else { return [] }
        
        let openAI = OpenAI(configuration: .init(token: apiKey, host: remoteUrl.host() ?? "localhost",
                                                 port: remoteUrl.port ?? 11434, scheme: remoteUrl.scheme ?? "https",
                                                 timeoutInterval: 30))
        
        let messages: [ChatQuery.ChatCompletionMessageParam] = [
            .init(role: .system, content: baseSystem)!,
            .init(role: .user, content: intent.prompt)!
        ]
        
        let query = ChatQuery(messages: messages, model: model, temperature: Double(temperature))
        let chatResults = try await openAI.chats(query: query);
        
        return chatResults.choices.map { $0.message.content?.string ?? "" }
    }
}

extension OllamaProvider.APIIntent {
    var prompt: String {
        switch self {
        case .documentation(let code):
            """
            \(code)
            
            Document provided code with inline documentation.
            Do not document external frameworks or SDKs.
            Ensure your documentation is clean, comprehensive and prone for misinterpretation.
            Ensure the results can be used direct in Xcode with no compilation error.
            Ensure to not change the provided code.
            Ensure inline comments for code documentation is used only if code is too complex.
            Document structures classes enums and functions using DocC syntax.
            No need to return markdown or any extra text.
            """
        case .generation(let prompt):
            "Generate Swift code attending to following instructions: \(prompt)"
        }
    }
}

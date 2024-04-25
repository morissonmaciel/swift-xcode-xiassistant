//
//  CodeGenerationChatViewModel.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 22/04/24.
//

import Foundation
import Observation

/**
 A model representing a chat message.
 */
struct ChatModel: Identifiable, Codable {
    /**
     The unique identifier for this chat message.
     */
    var id = UUID()
    
    /**
     The role of the user who sent this chat message (Assistant or User).
     */
    enum Role: String, CaseIterable, Codable {
        case assistant
        case user
    }
    
    /**
     The role of the user who sent this chat message.
     */
    var role: Role
    
    /**
     The contents of this chat message.
     */
    var contents: String
    
    /**
     Initializes a new `ChatModel` with the given role and contents.
     
     - parameter role: The role of the user who sent this chat message (Assistant or User).
     - parameter contents: The contents of this chat message.
     */
    init(role: Role, contents: String) {
        self.role = role
        self.contents = contents
    }
}

/**
 CodeGenerationChatViewModel: A class responsible for managing chat history and generating responses.
 */
@Observable final class CodeGenerationChatViewModel {
    /**
     Shared instance of the view model.
     */
    static let shared = CodeGenerationChatViewModel()

    /**
     User defaults used to store and load chat history.
     */
    private var userDefaults: UserDefaults

    /**
     The chat history, stored as an array of ChatModel objects.
     */
    var chatHistory: [ChatModel] = [] {
        didSet {
            // Saves the chat history when it changes
            saveChatHistory()
        }
    }

    /**
     Initializes the view model with user defaults and loads the initial chat history.
     */
    private init() {
        userDefaults = UserDefaults.standard
        chatHistory = loadChatHistory()
    }

    /**
     Asks a question and generates a response.

     - parameter prompt: The question to be asked.

     - returns: An empty tuple, as this function is marked as `async throws`.
     */
    func ask(prompt: String) async throws {
        // Adds the user's prompt to the chat history
        chatHistory.append(.init(role: .user, contents: prompt))

        let provider = OllamaProvider() // This line should be documented
        let results = try await provider.invoke(for: .generation(prompt))
        // Adds the assistant's response to the chat history
        chatHistory.append(.init(role: .assistant, contents: results.joined(separator: "\n")))
    }

    /**
     Saves the chat history to user defaults.
     */
    func saveChatHistory() {
        try? userDefaults.set(JSONEncoder().encode(chatHistory), forKey: "ChatHistory")
    }

    /**
     Loads the chat history from user defaults.

     - returns: An empty array if no data is found in user defaults.
     */
    func loadChatHistory() -> [ChatModel] {
        guard let data = userDefaults.data(forKey: "ChatHistory") else {
            return []
        }
        
        // Decodes the loaded data into a ChatModel array
        return (try? JSONDecoder().decode([ChatModel].self, from: data)) ?? []
    }
}

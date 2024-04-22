//
//  AssistantProvider.swift
//  Plugin
//
//  Created by Morisson Marcel on 30/03/24.
//

import Foundation

/**
 * This class provides methods to interact with an API endpoint for generating and documenting code.
 */
class AssistantProvider {
    private static let baseAPI = "http://localhost:3000/api/assistant"
    
    enum Errors: Error {
        case internalFailure
        case remoteFailure(String)
    }
    
    enum APIIntent {
        case documentation(String)
        case generation(String)
    }
    
    /**
     * Returns the URL for a given API intent.
     */
    private func getURL(for intent: APIIntent) -> URL? {
        switch intent {
        case .documentation:
            return URL(string: "\(Self.baseAPI)/doc")
        case .generation:
            return URL(string: "\(Self.baseAPI)/gen")
        }
    }
    
    /**
     * Invokes the API endpoint to generate or document code based on the provided intent and returns the generated code as a string array.
     */
    func invoke(for intent: APIIntent) async throws -> [String] {
        guard let url = getURL(for: intent) else { return [] }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.timeoutInterval = 10.0
        
        switch intent {
            case .documentation(let prompt):
                let jsonData = try JSONSerialization.data(withJSONObject: ["code": prompt])
                request.httpBody = jsonData
                
            case .generation(let intent):
                let jsonData = try JSONSerialization.data(withJSONObject: ["intent": intent])
                request.httpBody = jsonData
        }
        
        var streamlined = [String]()
        let (bytes, response) = try await URLSession.shared.bytes(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Errors.internalFailure
        }
        
        guard 200...210 ~= httpResponse.statusCode else {
            throw Errors.remoteFailure("\(httpResponse.statusCode) \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
        }
        
        for try await line in bytes.lines {
            streamlined.append(line)
        }
        
        return streamlined
    }
}


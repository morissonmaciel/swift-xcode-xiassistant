//
//  OllamaIntegrationSettings.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 19/04/24.
//

import Foundation
import Observation

@Observable final class OllamaIntegrationSettings {
    
    static let shared = OllamaIntegrationSettings()
    
    struct UserDefaultsKeys {
        static let useDefaultsKey = "Assistant.UseDefaults"
        static let remoteUrlKey = "Assistant.RemoteURL"
        static let apiKeyKey = "Assistant.APIKey"
        static let temperatureKey = "Assistant.Temperature"
        static let modelKey = "Assistant.Model"
    }
    
    var useDefaults: Bool { didSet { saveSettings() }}
    var remoteUrl: String { didSet { saveSettings() }}
    var apiKey: String { didSet { saveSettings() }}
    var temperature: Float { didSet { saveSettings() }}
    var model: String { didSet { saveSettings() }}
    
    private init() {
        useDefaults = true
        remoteUrl = "http://localhost:11434/v1"
        apiKey = "ollama"
        temperature = 0.1
        model = "llama3"
    }

    func saveSettings() {
        UserDefaults.standard.set(useDefaults, forKey: UserDefaultsKeys.useDefaultsKey)
        UserDefaults.standard.set(remoteUrl, forKey: UserDefaultsKeys.remoteUrlKey)
        UserDefaults.standard.set(apiKey, forKey: UserDefaultsKeys.apiKeyKey)
        UserDefaults.standard.set(temperature, forKey: UserDefaultsKeys.temperatureKey)
        UserDefaults.standard.set(model, forKey: UserDefaultsKeys.modelKey)
    }

    func loadSettings() {
        useDefaults = UserDefaults.standard.bool(forKey: UserDefaultsKeys.useDefaultsKey)

        if let value = UserDefaults.standard.string(forKey: UserDefaultsKeys.remoteUrlKey) {
            remoteUrl = value
        }

        apiKey = UserDefaults.standard.string(forKey: UserDefaultsKeys.apiKeyKey) ?? ""

        temperature = UserDefaults.standard.float(forKey: UserDefaultsKeys.temperatureKey)

        if let value = UserDefaults.standard.string(forKey: UserDefaultsKeys.modelKey) {
            model = value
        }
    }
}

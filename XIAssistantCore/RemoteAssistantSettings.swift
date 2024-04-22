//
//  RemoteAssistantSettings.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 19/04/24.
//

import Foundation
import Observation

@Observable final class RemoteAssistantSettings {
    
    struct UserDefaultsKeys {
        static let remoteURLKey = "Assistant.RemoteURL"
        static let apiDocPathKey = "Assistant.DocAPIPath"
        static let apiGenPathKey = "Assistant.GenAPIPath"
    }
    
    var remoteUrl: String { didSet { saveSettings() }}
    var apiDocPath: String { didSet { saveSettings() }}
    var apiGenPath: String { didSet { saveSettings() }}
    
    init() {
        remoteUrl = "http://localhost:3000/api/assistant"
        apiDocPath = "/doc"
        apiGenPath = "/gen"
    }
    
    func saveSettings() {
        UserDefaults.standard.setValue(remoteUrl, forKey: UserDefaultsKeys.remoteURLKey)
        UserDefaults.standard.setValue(apiDocPath, forKey: UserDefaultsKeys.apiDocPathKey)
        UserDefaults.standard.setValue(apiGenPath, forKey: UserDefaultsKeys.apiGenPathKey)
    }

    func loadSettings() {
        if let value = UserDefaults.standard.string(forKey: UserDefaultsKeys.remoteURLKey) {
            remoteUrl = value
        }
        
        if let value = UserDefaults.standard.string(forKey: UserDefaultsKeys.apiDocPathKey) {
            apiDocPath = value
        }
        
        if let value = UserDefaults.standard.string(forKey: UserDefaultsKeys.apiGenPathKey) {
            apiGenPath = value
        }
    }
}

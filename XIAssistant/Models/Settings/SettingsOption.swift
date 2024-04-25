//
//  SettingsOption.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 22/04/24.
//

import Foundation
import SwiftUI

enum SettingsOption: String, CaseIterable {
    case ollama = "Ollama"
    case codeDocumentation = "Documentation"
    case codeGeneration = "Code Generation"
}

extension SettingsOption {
    var title: String {
        self.rawValue
    }
    
    var imageName: String {
        return switch self {
        case .ollama:
            "brain"
        case .codeDocumentation:
            "doc.append"
        case .codeGeneration:
            "greaterthan.square"
        }
    }
}

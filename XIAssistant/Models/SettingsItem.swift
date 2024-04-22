//
//  SettingsItem.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 22/04/24.
//

import Foundation
import SwiftUI

struct SettingsLabel {
    let title: String
    let systemImage: String
}

enum SettingsItem: String, CaseIterable {
    case general = "General"
    case llm = "LLM"
    case docgen = "Documentation"
    case codegen = "Code Generation"
}

extension SettingsItem {
    var label: SettingsLabel {
        let imageName = switch self {
        case .general:
            "gear"
        case .llm:
            "brain"
        case .docgen:
            "doc.append"
        case .codegen:
            "greaterthan.square"
        }
        
        return SettingsLabel(title: self.rawValue, systemImage: imageName)
    }
}

//
//  RootView.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 28/03/24.
//

import SwiftUI

struct RootView: View {
    @State private var selected = SettingsItem.general
    
    func DetailsView(for item: SettingsItem) -> some View {
        return Group {
            switch item {
            case .general:
                AssistantSettingsScreen()
            case .llm:
                LLMSettingsScreen()
            default:
                EmptyView()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(SettingsItem.allCases, id: \.self, selection: $selected) { item in
                let label = item.label
                
                return NavigationLink(destination: {
                    DetailsView(for: item)
                        .navigationTitle(label.title)
                }) {
                    Label(label.title, systemImage: label.systemImage)
                }
            }
            .listStyle(.sidebar)
        }
    }
}

#Preview {
    RootView()
}

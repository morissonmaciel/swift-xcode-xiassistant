//
//  RootView.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 28/03/24.
//

import SwiftUI

struct RootView: View {
    @State private var current = SettingsOption.codeGeneration
    @State private var navigationHistory: [SettingsOption] = []
    @State private var isHistoryNavigation = false
    
    func DetailsView(for item: SettingsOption) -> some View {
        return Group {
            switch item {
            case .ollama:
                OllamaSettingsScreen()
            case .codeDocumentation:
                CodeDocumentationScreen()
            case .codeGeneration:
                CodeGenerationChatScreen()
            default:
                EmptyView()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(SettingsOption.allCases, id: \.self, selection: $current) { option in
                NavigationLink(destination: {
                    DetailsView(for: option)
                        .navigationTitle(option.title)
                }) {
                    Label(option.title, systemImage: option.imageName)
                }
            }
            .listStyle(.sidebar)
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                HStack {
                    Button {
                        isHistoryNavigation = true
                        current = navigationHistory.removeLast()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(navigationHistory.isEmpty)
                }
            }
        }
        .onChange(of: current) { previous, next in
            guard previous != next, !isHistoryNavigation else {
                isHistoryNavigation = false
                return
            }
            
            navigationHistory.append(previous)
            isHistoryNavigation = false
        }
    }
}

#Preview {
    RootView()
}

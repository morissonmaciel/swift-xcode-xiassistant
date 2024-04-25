//
//  OllamaSettingsScreen.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 15/04/24.
//

import SwiftUI

struct OllamaSettingsScreen: View {
    @Bindable var settings = OllamaIntegrationSettings.shared
    
    var body: some View {
        Form {
            Section {
                Toggle("Use remote LLM settings defaults", isOn: $settings.useDefaults)
            
                TextField("Ollama endpoint", text: $settings.remoteUrl)
                    .textFieldStyle(.roundedBorder)
                    .disabled(settings.useDefaults)
                
                TextField("Ollama integration key", text: $settings.apiKey)
                    .textFieldStyle(.roundedBorder)
                    .disabled(settings.useDefaults)
            } header: {
                Text("Remote Settings")
            } footer: {
                Text("If set, overrides remote Ollama endpoint address and api integration key")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Section {
                Picker("Model", selection: $settings.model) {
                    ForEach(["llama3", "codellama", "dolphin-mistral"], id: \.self) {
                        Text($0).tag($0)
                    }
                }
                
                HStack {
                    Stepper("Temperature", value: $settings.temperature, in: 0...1, step: 0.1)
                    Text(settings.temperature, format: .number)
                }
            }
        }
        .onAppear {
            settings.loadSettings()
        }
        .padding()
        .formStyle(.grouped)
    }
}

#Preview {
    OllamaSettingsScreen()
}

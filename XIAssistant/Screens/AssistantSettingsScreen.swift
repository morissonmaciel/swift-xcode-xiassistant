//
//  AssistantSettingsScreen.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 19/04/24.
//

import SwiftUI
import Observation

struct AssistantSettingsScreen: View {
    @Bindable private var settings = RemoteAssistantSettings()
    @State private var testLog: [String] = []
    private var provider = AssistantProvider()
    
    private func testGenerationCall() async {
        testLog.append("Testing generation code at \(settings.remoteUrl)\(settings.apiGenPath) ...")
        
        do {
            let results = try await provider.invoke(for: .generation("simple swiftui button"))
            testLog.append("Test succeeded with \(results.count) characters")
        } catch let failure as AssistantProvider.Errors {
            let message = switch failure {
            case .internalFailure:
                "Internal Error"
            case .remoteFailure(let associatedError):
                associatedError
            }
            
            testLog.append("Test failed with: \(message)")
        } catch {
            testLog.append("Test failed with: \(error.localizedDescription)")
        }
    }

    private func testDocumentationCall() async {
        testLog.append("Testing code documentation at \(settings.remoteUrl)\(settings.apiDocPath) ...")
        
        do {
            let results = try await provider.invoke(for: .documentation("final class MyView: UIView { }"))
            testLog.append("Test succeeded with \(results.count) characters")
        } catch let failure as AssistantProvider.Errors {
            let message = switch failure {
            case .internalFailure:
                "Internal Error"
            case .remoteFailure(let associatedError):
                associatedError
            }
            
            testLog.append("Test failed with: \(message)")
        } catch {
            testLog.append("Test failed with: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Ollama endpoint", text: $settings.remoteUrl)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Documentation endpoint path", text: $settings.apiDocPath)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Code Generation endpoint path", text: $settings.apiGenPath)
                    .textFieldStyle(.roundedBorder)
            } footer: {
                Text("Main integration of Xcode plugin assistant features with remote assistant API")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Section {
                Button {
                    testLog = []
                    
                    Task {
                        await testGenerationCall()
                        await testDocumentationCall()
                    }
                } label: {
                    Text("Test API Call")
                }
                
                List(Array(testLog.enumerated()), id: \.0) {
                    Text($0.1)
                        .font(.system(.footnote, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 4.0)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .listStyle(.plain)
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
    AssistantSettingsScreen()
}

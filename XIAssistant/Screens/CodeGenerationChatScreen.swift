//
//  CodeGenerationChatScreen.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 22/04/24.
//

import SwiftUI
import AppKit
import MarkdownUI

struct CodeGenerationChatScreen: View {
    private var viewModel = CodeGenerationChatViewModel.shared
    @State private var prompt: String = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.chatHistory) { chat in
                            VStack(alignment: .leading) {
                                Text("\(chat.role.rawValue):")
                                    .fontDesign(.monospaced)
                                    .fontWeight(.semibold)
                                
                                Markdown(chat.contents)
                                    .markdownTheme(.docC)
                                    .textSelection(.enabled)
                                    .fontDesign(.monospaced)
                            }
                            .padding(.bottom)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8.0)
                        .fill(Color(.quaternarySystemFill))
                        .stroke(Color(.separatorColor), lineWidth: 0.5)
                )
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        viewModel.chatHistory = []
                    } label: {
                        Label("Clear History ", systemImage: "delete.left")
                    }
                }
            }
            .padding(.horizontal, 24.0)
            .padding(.top, 24.0)
            .padding(.bottom, 16.0)
            
            VStack {
                HStack {
                    TextField("Ask something", text: $prompt)
                        .textFieldStyle(.roundedBorder)
                        .disabled(isLoading)
                        .labelsHidden()
                    
                    Button {
                        Task {
                            let originalPrompt = prompt
                            isLoading = true
                            prompt = ""

                            do {
                                try await viewModel.ask(prompt: originalPrompt)
                            } catch {
                                print("Error asking question: \(error)")
                            }
                            isLoading = false
                        }
                    } label: {
                        Text("Send")
                    }
                    .disabled(isLoading)
                    
                    if isLoading {
                        ActivityIndicatorView(style: .spinning)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8.0)
                        .fill(Color(.quaternarySystemFill))
                        .stroke(Color(.separatorColor), lineWidth: 0.5)
                )
            }
            .padding(.horizontal, 24.0)
            .padding(.bottom, 24.0)
        }
        .formStyle(.grouped)
    }
}

#Preview {
    CodeGenerationChatScreen()
}

//
//  CodeDocumentationScreen.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 22/04/24.
//

import SwiftUI
import AppKit
import MarkdownUI

struct CodeDocumentationScreen: View {
    @State private var sourceCode: String = ""
    @State private var isLoading = false
    @Bindable private var viewModel = CodeDocumentationViewModel()
    
    var body: some View {
        Form {
            Section {
                TextEditor(text: $viewModel.currentCode)
                    .fontDesign(.monospaced)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .overlay(
                        Group {
                            if viewModel.currentCode.isEmpty {
                                Text("Paste code using Copy from Clipboard button")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    )
            }
            
            HStack {
                if isLoading {
                    ActivityIndicatorView(style: .spinning)
                }
                
                Spacer()
                
                Button {
                    Task {
                        isLoading = true
                        do {
                            try await viewModel.invoke()
                        } catch {
                            isLoading = false
                        }
                        isLoading = false
                    }
                } label: {
                    Text("Document Code")
                }
                .disabled(isLoading)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    guard !isLoading,
                          let clipboardString = NSPasteboard.general.string(forType: .string) else { return }
                    viewModel.currentCode = clipboardString
                } label: {
                    Label("Paste from Clipboard", systemImage: "doc.on.clipboard")
                }
            }
        }
        .padding()
    }
}

#Preview {
    CodeDocumentationScreen()
}

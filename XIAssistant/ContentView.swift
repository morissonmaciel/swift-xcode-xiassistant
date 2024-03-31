//
//  ContentView.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 28/03/24.
//

import SwiftUI

struct AccentButton: View {
    @State private var isPressed = false
    let title: String
    let color: Color
    var body: some View {
        Button(action: { self.isPressed.toggle() }) {
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .background(
                    Circle().fill(color).scaleEffect(isPressed ? 0.9 : 1)
                )
        }
    }
}

struct ContentView: View {
    @State private var temperature = 0.1
    @State private var model = "codellama"
    var body: some View {
        Form {
            Section {
                VStack {
                    Slider(value: $temperature, in: 0...100, step: 0.1) {
                        Text("Temperature")
                    }
                }
            }
            
            Section {
                VStack {
                    Picker("Model", selection: $model) {
                        ForEach(["codellama", "dolphin-mistral"], id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                    .pickerStyle(.automatic)
                }
            }
            
            Button {
                
            } label: {
                Text("Save")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

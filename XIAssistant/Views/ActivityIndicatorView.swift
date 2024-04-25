//
//  ActivityIndicatorView.swift
//  XIAssistant
//
//  Created by Morisson Marcel on 22/04/24.
//

import SwiftUI

struct ActivityIndicatorView: NSViewRepresentable {
    typealias NSViewType = NSProgressIndicator
    let style: NSProgressIndicator.Style
    
    func makeNSView(context: Context) -> NSProgressIndicator {
        let indicator = NSProgressIndicator()
        indicator.style = .spinning
        indicator.controlSize = .small
        indicator.isIndeterminate = true
        indicator.startAnimation(nil)
        return indicator
    }
    
    func updateNSView(_ nsView: NSProgressIndicator, context: Context) {
        // No updates needed
    }
}

#Preview {
    Form {
        HStack {
            Text("Loading...")
            ActivityIndicatorView(style: .spinning)
        }
    }.padding()
}

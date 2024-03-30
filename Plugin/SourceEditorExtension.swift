//
//  SourceEditorExtension.swift
//  Plugin
//
//  Created by Morisson Marcel on 28/03/24.
//

import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    static var shared: SourceEditorExtension?
    
    func extensionDidFinishLaunching() {
        Self.shared = self
    }
    
    /*
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
        return []
    }
    */
    
}

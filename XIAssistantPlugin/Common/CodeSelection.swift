//
//  CodeSelection.swift
//  Plugin
//
//  Created by Morisson Marcel on 30/03/24.
//

import Foundation

typealias CodeSelection = [String]

extension CodeSelection {
    func toString() -> String {
        self.joined(separator: "\n")
    }
}

//
//  Note.swift
//  Notes
//
//  Created by Arvin Shen on 1/8/22.
//

import Foundation

class Note: NSObject, Codable {
    var firstLine: String
    var text: String
    
    init(firstLine: String, text: String) {
        self.firstLine = firstLine
        self.text = text
    }
}

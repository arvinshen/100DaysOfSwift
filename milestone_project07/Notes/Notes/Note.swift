//
//  Note.swift
//  Notes
//
//  Created by Arvin Shen on 1/8/22.
//

import Foundation

class Note: NSObject, Codable {
    var header: String
    var body: String
    var text: String
    
    init(header: String, body: String, text: String) {
        self.header = header
        self.body = body
        self.text = text
    }
}

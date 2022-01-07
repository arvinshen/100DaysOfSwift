//
//  Script.swift
//  Extension
//
//  Created by Arvin Shen on 1/6/22.
//

import Foundation

class Script: NSObject, Codable {
    var name: String
    var pageTitle: String
    var pageURL: String
    var javaScript: String
    
    init(name: String, pageTitle: String, pageURL: String, javaScript: String) {
        self.name = name
        self.pageTitle = pageTitle
        self.pageURL = pageURL
        self.javaScript = javaScript
    }
}

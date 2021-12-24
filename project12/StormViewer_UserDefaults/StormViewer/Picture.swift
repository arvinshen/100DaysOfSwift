//
//  Picture.swift
//  StormViewer
//
//  Created by Arvin Shen on 12/23/21.
//

import Foundation

class Picture: NSObject, Codable {
    var name: String
    var viewCount: Int
    
    init(name: String, viewCount: Int) {
        self.name = name
        self.viewCount = viewCount
    }
}

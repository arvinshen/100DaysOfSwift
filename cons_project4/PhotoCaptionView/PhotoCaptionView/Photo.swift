//
//  Photo.swift
//  PhotoCaptionView
//
//  Created by Arvin Shen on 12/27/21.
//

import Foundation

class Photo: NSObject, Codable {
    var name: String
    var caption: String
    
    init(name: String, caption: String) {
        self.name = name
        self.caption = caption
    }
}

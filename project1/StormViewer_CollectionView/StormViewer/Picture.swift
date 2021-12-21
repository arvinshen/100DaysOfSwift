//
//  Picture.swift
//  StormViewer
//
//  Created by Arvin Shen on 12/20/21.
//

import UIKit

class Picture: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

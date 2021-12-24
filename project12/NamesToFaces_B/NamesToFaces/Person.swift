//
//  Person.swift
//  NamesToFaces
//
//  Created by Arvin Shen on 12/19/21.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

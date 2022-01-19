//
//  MemeTemplates.swift
//  MemeGenerator
//
//  Created by Arvin Shen on 1/17/22.
//

import Foundation

struct MemeTemplates: Decodable, Identifiable {
    var id: UUID
    var name: String
    var url: String
    var width: Int
    var height: Int
    var box_count: Int
}

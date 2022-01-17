//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by Arvin Shen on 12/7/21.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

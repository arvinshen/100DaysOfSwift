//
//  Country.swift
//  CountryDB
//
//  Created by Arvin Shen on 1/3/22.
//

import Foundation

struct Country: Codable {
    var country: String
    var abbreviation: String
    var city: String?
    var continent: String
    var currency_code: String?
    var currency_name: String?
    var government: String?
    var independence: Int?
    var languages: [String]
    var population: Int
    var location: String?
}

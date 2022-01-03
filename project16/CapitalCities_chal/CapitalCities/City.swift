//
//  City.swift
//  CapitalCities
//
//  Created by Arvin Shen on 1/2/22.
//

import Foundation

struct City: Codable {
    var city: String
    var city_ascii: String
    var city_url: String
    var lat: Double
    var long: Double
    var country: String
    var iso2: String
    var iso3: String
    var admin_name: String
    var capital: String
    var population: Int
    var id: Int
}

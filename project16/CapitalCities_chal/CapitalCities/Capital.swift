//
//  Capital.swift
//  CapitalCities
//
//  Created by Arvin Shen on 1/2/22.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var city_url: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, city_url: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.city_url = city_url
    }
}

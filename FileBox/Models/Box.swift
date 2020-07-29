//
//  Box.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 24.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Foundation
import CoreLocation

struct Box : Encodable, Decodable {
    var id: String
    var name: String
    var lat: Double
    var lng: Double
    var altitude: Double
    
    init(id: String, dto: BoxCreateDTO) {
        self.id = id
        name = dto.name
        lat = dto.lat
        lng = dto.lng
        altitude = dto.altitude
    }
    
    func getLocation() -> CLLocation {
        let loc2 = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        return CLLocation(coordinate: loc2, altitude: altitude)
        
    }
}

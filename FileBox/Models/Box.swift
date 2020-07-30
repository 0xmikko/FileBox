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
    var location: [Double]
    var altitude: Double
    var ipfsHash: String?
    var content: String
    var opened: Int
    var downloaded : Int
    

    // Return CLLLocation object based on Box parameters
    func getLocation() -> CLLocation {
        let loc2 = CLLocationCoordinate2D(latitude: location[0], longitude: location[1])
        return CLLocation(coordinate: loc2, altitude: altitude)
        
    }
    
    // Calculates distance in km based on Box data and location parameter
    func getDistance(location: CLLocation) -> Double {
        return 0.0
    }
}

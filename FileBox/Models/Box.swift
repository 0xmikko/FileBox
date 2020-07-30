//
//  Box.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 24.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import CoreLocation
import Foundation

struct Box: Encodable, Decodable {
    var id: String
    var name: String
    var location: [Double]
    var altitude: Double
    var ipfsHash: String?
    var content: String
    var opened: Int
    var downloaded: Int
    var distance: Double?
    
    // Return CLLLocation object based on Box parameters
    func getLocation() -> CLLocation {
        let loc2 = CLLocationCoordinate2D(latitude: location[0], longitude: location[1])
        return CLLocation(coordinate: loc2, altitude: altitude)
    }
    
    func getHumanDistance() -> String {
        guard let distance = self.distance else { return "-" }
        if distance < 1000.0 {
            return "\(round(distance)) m"
        } else if distance < 10000.0 {
            return "\(round(distance/100)/10) km"
        }
        
        return "\(round(distance/1000)) km"
    }
    
    // Calculates distance in km based on Box data and location parameter
    func getBoxWithDistance(location: CLLocation) -> Box {
        var newBox = self
        newBox.distance = location.distance(from: getLocation())
        return newBox
    }
}

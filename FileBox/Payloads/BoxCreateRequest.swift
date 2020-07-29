//
//  BoxCreateRequest.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 29.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Foundation

struct BoxCreateDTO: Encodable {
    var name: String
    var lat: Double
    var lng: Double
    var altitude: Double
}

//
//  BoxListResponse.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 30.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Foundation

struct BoxListResponse : Decodable {
    var near : [Box]
    var top: [Box]
}

//
//  Auth.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 01.08.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Foundation
import SwiftJWT

struct TokenPair: Decodable {
    var access: String
    var refresh: String
}

struct Claims : SwiftJWT.Claims {
    var user_id: String
    var exp: Int64
}

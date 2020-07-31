//
//  Auth.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 31.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Foundation

struct TokenPair: Decodable {
    var access: String
    var refresh: String
}

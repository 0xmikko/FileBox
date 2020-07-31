//
//  UserService.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 31.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Alamofire
import Foundation

class AuthService {
    func loginWithCode(code: String, name: String?, completion: @escaping (TokenPair) -> Void) {
        
        let parameters: [String: String] = [
            "code": code,
            "name": name ?? "",
        ]
        
        AF.request(getFullURL(url: "/auth/login/apple/done/"), method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)

            .responseDecodable(of: TokenPair.self) { response in
                do {
                    print("Getting data back!", response)
                    let tokenPair = try response.result.get()
                    print(tokenPair)
                    completion(tokenPair)

                } catch {
                    print("Error, cant get ID")
                }
            }
    }
}

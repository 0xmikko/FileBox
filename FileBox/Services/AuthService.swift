//
//  UserService.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 31.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Alamofire
import Foundation
import KeychainAccess
import SwiftJWT

class AuthService {
    static let auth = AuthService()
    
    var isSignIn: Bool {
        return isRefreshTokenValid()
    }
    
    private var accessToken: String?
    private var refreshToken: String?
    
    private init() {
        refreshToken = getTokenFromKeyChain()
    }
    
    func isAccessTokenValid() -> Bool {
        return isTokenValid(token: accessToken)
    }
    
    func isRefreshTokenValid() -> Bool {
        return isTokenValid(token: refreshToken)
    }
    
    func isTokenValid(token: String?) -> Bool {
        guard let token = token else { return false }
        do {
            // Parse jwt with Claims
            let jwt = try JWT<Claims>(jwtString: token)
            
            // Getting expiration with unix timestamp
            let exp = jwt.claims.exp
            
            // Check it's not expired
            return Date() < Date(timeIntervalSince1970: TimeInterval(exp))
            
        } catch {
            print("Failed to decode JWT: \(error)")
            return false
        }
    }
    
    func getTokenFromKeyChain() -> String? {
        let keychain = Keychain(service: "com.dtexperts.filebox")
        let token = try? keychain.getString("refreshToken")
        return token
    }
    
    func saveTokenToKeyChain(token: String) {
        let keychain = Keychain(service: "com.dtexperts.filebox")
        keychain["refreshToken"] = token
    }
    
    func loginWithCode(code: String, name: String?) {
        let parameters: [String: String] = [
            "code": code,
            "name": name ?? "",
        ]
        
        AF.request(getFullURL(url: "/auth/login/apple/done/"),
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default)
            
            .responseDecodable(of: TokenPair.self) { response in
                do {
                    print("Getting data back!", response)
                    let tokenPair = try response.result.get()
                    self.updateTokenPair(tokenPair)
                    if self.isSignIn {
                        self.saveTokenToKeyChain(token: tokenPair.refresh)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.swithToMainSB()
                    }
                    
                } catch {
                    print("Network error \(error)")
                }
            }
    }
    
    func refreshTokenPair() {
        guard let token = refreshToken else { return }
        let parameters: [String: String] = [
            "refresh": token,
        ]
        
        AF.request(getFullURL(url: "/auth/token/refresh/"),
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default)
            
            .responseDecodable(of: TokenPair.self) { response in
                print("Getting data back!", response)
                do {
                    let tokenPair = try response.result.get()
                    self.updateTokenPair(tokenPair)
                    if !self.isSignIn {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.switchToLoginSB()
                    }
                } catch {
                    print("Network error \(error)")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.switchToLoginSB()
                }
            }
    }
    
    private func updateTokenPair(_ tokenPair: TokenPair) {
        accessToken = tokenPair.access
        refreshToken = tokenPair.refresh
    }
}

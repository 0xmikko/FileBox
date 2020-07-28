//
//  File.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 28.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Foundation

struct Preferences: Codable {
    var isDevMode: Bool
    var prodBackendURL: String
    var devBackendURL: String
}

func loadConfig() {
    if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
        let xml = FileManager.default.contents(atPath: path),
        let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml) {
        let backendURL = preferences.isDevMode ? preferences.devBackendURL : preferences.prodBackendURL
        print("[Starting] Backend: \(backendURL)")
        UserDefaults.standard.set(backendURL, forKey: "BackendURL")
    }
}

func getFullURL(url: String) -> String {
    return (UserDefaults.standard.string(forKey: "BackendURL") ?? "") + url
}

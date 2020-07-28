//
//  ipfsService.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 24.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Alamofire
import Foundation

class IPFSService {
    init() {}

    func getFile(id: String) {}

    func saveFile(url: URL) {
        let data = try! Data(contentsOf: url)
        print("DATA", data)

//        let data = Data("data".utf8)

        AF.upload(multipartFormData: {
            multipartFormData in
            multipartFormData.append(url, withName: "file")
        }, to: getFullURL(url: "/api/boxes/"))

            .responseDecodable(of: IPFSUploadResponse.self) { response in
                debugPrint(response)
            }
            .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }
    }
}

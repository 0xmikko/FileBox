//
//  ipfsService.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 24.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Alamofire
import Foundation

protocol IPFSServiceDelegate {
    func addBox(box: Box)
}

class IPFSService {
    var delegate: IPFSServiceDelegate?

    func getFile(id: String) {}

    func saveFile(boxDTO: BoxCreateDTO, url: URL) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(boxDTO)

            AF.upload(multipartFormData: {
                multipartFormData in
                multipartFormData.append(jsonData, withName: "box")
                multipartFormData.append(url, withName: "file")
            }, to: getFullURL(url: "/api/boxes/"))

                .responseDecodable(of: Box.self) { response in
                    do {
                        print("Getting data back!", response)
                        let newBox = try response.result.get()
                        self.delegate?.addBox(box: newBox)

                    } catch {
                        print("Error, cant get ID")
                    }
                }
                .uploadProgress { progress in
                    print("Upload Progress: \(progress.fractionCompleted)")
                }
        } catch {
            return
        }
    }
}

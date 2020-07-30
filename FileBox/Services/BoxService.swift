//
//  ipfsService.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 24.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Alamofire
import CoreLocation
import Foundation

class BoxService {
    // Creates box on server and return new Box
    func createBox(boxDTO: BoxCreateDTO, url: URL, completion: @escaping (Box) -> Void) {
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
                        completion(newBox)

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

    // Get box details
    func getBox(id: String, completetion: @escaping (Box) -> Void) {
        AF.request(getFullURL(url: "/api/boxes/i/\(id)/"))

            .responseDecodable(of: Box.self) { response in
                do {
                    print("Getting data back!", response)
                    let newBox = try response.result.get()
                    completetion(newBox)

                } catch {
                    print("Error, cant get ID")
                }
            }
    }

    func downloadFromBox(id: String, completion: @escaping (URL?) -> Void) {
        AF.download(getFullURL(url: "/api/boxes/d/\(id)/"))
            .responseData { response in
                if let data = response.value {
                    print("Downloaded", data)

                    completion(response.fileURL)
                }
            }
    }

    // Get array of boxes around providing coordinates and top boxes also
    func getBoxesAround(position: CLLocationCoordinate2D, completetion: @escaping (BoxListResponse) -> Void) {
        AF.request(getFullURL(url: "/api/boxes/?lat=\(position.latitude)&lng=\(position.longitude)"))
            .responseDecodable(of: BoxListResponse.self) { response in
                do {
                    print("Getting data back!", response)
                    let newBoxesListResponse = try response.result.get()
                    completetion(newBoxesListResponse)

                } catch {
                    print("Error, cant get ID")
                }
            }
    }
}

//
//  BoxViewModel.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 28.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import CoreLocation
import Foundation
import SceneKit

protocol BoxViewModelDelegate {
    func updateScore(newScore: Int)
    func updateFilesNearby(withNewValue value: Int)
    func addBox(id: String, location: CLLocation)
    func updateButtonState(state: Bool)
    func showBoxDetails(id: String)
}

class BoxViewModel {
    var delegate: BoxViewModelDelegate?
    var boxService: BoxService
    
    var boxes: [String: Box] = [:]
    var lastUpdateLocation: CLLocation?
    
    var readyForLaunch: Bool = false
    var score: Int = 1
    
    init() {
        boxService = BoxService()
    }
    
    func createBox(url: URL, location: CLLocation) {
        let boxCreateDTO = BoxCreateDTO(name: url.lastPathComponent,
                                        lat: location.coordinate.latitude,
                                        lng: location.coordinate.longitude,
                                        altitude: location.altitude)
        
        boxService.createBox(boxDTO: boxCreateDTO, url: url) { box in
            self.addBox(box: box)
        }
    }
    
    func addBox(box: Box) {
        boxes[box.id] = box
        print(boxes)
        
        delegate?.addBox(id: box.id, location: box.getLocation())
        score += 1
        delegate?.updateScore(newScore: score)
    }
    
    func openBox(id: String) {
        delegate?.showBoxDetails(id: id)
    }
    
    func updateLocationFromServer(_ position: CLLocationCoordinate2D) {
        boxService.getBoxesAround(position: position) { boxes in
            let nearBoxes = boxes.near
            nearBoxes.forEach { box in
                if self.boxes[box.id] == nil {
                    print("Ading box from server")
                    self.delegate?.addBox(id: box.id, location: box.getLocation())
                }
                self.boxes[box.id] = box
            }
            self.delegate?.updateFilesNearby(withNewValue: nearBoxes.count)
        }
        
    }
    
    func onNewCoordinate(location: CLLocation) {
        if lastUpdateLocation == nil || lastUpdateLocation?.distance(from: location) ?? 1001.0 > 1000.0 {
            print("Requested new boxes")
            updateLocationFromServer(location.coordinate)
            lastUpdateLocation = location
        }
    }
}

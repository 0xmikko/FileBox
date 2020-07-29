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
    var ipfsService: BoxService
    
    var boxes: [String: Box] = [:]
    
    var readyForLaunch: Bool = false
    var score: Int = 1
    
    init() {
        ipfsService = BoxService()
    }
    
    public func dropFileTouch(position: SCNVector3) {
        readyForLaunch = false
        
        delegate?.updateButtonState(state: true)
    }
    
    func createBox(url: URL, location: CLLocation) {
        let boxCreateDTO = BoxCreateDTO(name: url.lastPathComponent,
                                        lat: location.coordinate.latitude,
                                        lng: location.coordinate.longitude,
                                        altitude: location.altitude)
        
        ipfsService.createBox(boxDTO: boxCreateDTO, url: url) { box in
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
    
    
}

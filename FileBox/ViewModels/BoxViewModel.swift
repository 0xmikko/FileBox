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
}

class BoxViewModel: IPFSServiceDelegate {
    var delegate: BoxViewModelDelegate?
    var ipfsService: IPFSService
    
    var boxes: Dictionary<String, Box> = [:]
    
    var readyForLaunch: Bool = false
    var score: Int = 1
    
    init() {
        ipfsService = IPFSService()
        ipfsService.delegate = self
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
        
        ipfsService.saveFile(boxDTO: boxCreateDTO, url: url)
       
    }
    
    func addBox(box: Box) {
        boxes[box.id] = box
        print(boxes)
        
        delegate?.addBox(id: box.id, location: box.getLocation())
        score += 1
        delegate?.updateScore(newScore: score)
    }
    
    func getBox(id: String)  {
        print(boxes[id] ?? "No box found")
    }
    
    
    func updateBoxes(boxes: [Box]) {
        
    }
}

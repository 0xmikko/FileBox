//
//  BoxViewModel.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 28.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Foundation
import SceneKit

protocol BoxViewModelDelegate {
    func updateScore(newScore: Int)
    func updateFilesNearby(withNewValue value: Int)
    func addBoxToScene(name: String, position: SCNVector3)
    func updateButtonState(state: Bool)
}

class BoxViewModel : IPFSServiceDelegate {
    
    
    var delegate: BoxViewModelDelegate?
    var ipfsService: IPFSService
    
    var boxes : [Box] = []
    
    var readyForLaunch: Bool = false
    var score: Int = 1
    
    init() {
        ipfsService = IPFSService()
    }
    
    public func dropFileTouch(position: SCNVector3) {
        let currentFileId = "12312312"
        delegate?.addBoxToScene(name: currentFileId, position: position)
        
        
        readyForLaunch = false
        score += 1
        
        delegate?.updateScore(newScore: score)
        delegate?.updateButtonState(state: true)
    }
    
    func uploadFile(url: URL) {
        ipfsService.saveFile(url: url)
    }
    
    func updateBoxes(boxes: [Box]) {
        self.boxes = boxes
    }
    
}

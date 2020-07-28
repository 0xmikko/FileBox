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
   func addBoxToScene(position: SCNVector3)
}

class BoxViewModel {
    var delegate : BoxViewModelDelegate?
    var ipfsService : IPFSService
    
    init() {
        ipfsService = IPFSService()
    }
    
    func uploadFile(url: URL) {
        ipfsService.saveFile(url: url)
    }
    
}

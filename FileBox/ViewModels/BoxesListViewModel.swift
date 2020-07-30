//
//  BoxesListViewModel.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 30.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import CoreLocation
import Foundation

protocol BoxesListViewModelDelegate {
    func updateBoxesData(near: [Box], top: [Box])
}

class BoxesListViewModel {
    var delegate: BoxesListViewModelDelegate?
    var boxService: BoxService
    
    init() {
        boxService = BoxService()
    }
    
    func loadData(location: CLLocation) {
        boxService.getBoxesAround(position: location.coordinate) { list in
            // add distance property
            let newBoxes = list.near.map {box in
                return box.getBoxWithDistance(location: location)
            }
            
            let topBoxes = list.top.map {box in
                           return box.getBoxWithDistance(location: location)
                       }
            self.delegate?.updateBoxesData(near: newBoxes, top: topBoxes)
        }
    }
    
}

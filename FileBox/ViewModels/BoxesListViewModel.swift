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
    
    func loadData() {
        boxService.getBoxesAround { list in
            self.delegate?.updateBoxesData(near: list.near, top: list.top)
        }
    }
    
    func calculateDistances() {
        let startLocation: CLLocation = CLLocation(latitude: 23.0952779, longitude: 72.5274129)
        let endLocation: CLLocation = CLLocation(latitude: 23.0981711, longitude: 72.5294229)
        let distance = startLocation.distance(from: endLocation)
        print(distance)
    }
}

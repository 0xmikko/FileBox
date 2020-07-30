//
//  BoxesListViewModel.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 30.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Foundation

protocol BoxesListViewModelDelegate {
    func updateBoxesData(near: [Box], top: [Box])
}

class BoxesListViewModel {
    
    var delefate : BoxesListViewModelDelegate?
    var boxService: BoxService
    
    init() {
        boxService = BoxService()
    }
    
    func loadData() {
        boxService.getBoxesAround() { list in
            print(list)
        }
    }
    
}

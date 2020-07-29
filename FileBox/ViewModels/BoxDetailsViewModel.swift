//
//  BoxDetailsViewModel.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 29.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Foundation

class BoxDetailsViewModel {
    var boxService: BoxService
    var box: Box?
    
    init() {
        boxService = BoxService()
    }
    
    func loadDetails(id: String) {
        boxService.getBox(id: id) { box in
            print(box)
            
        }
        
    }
}

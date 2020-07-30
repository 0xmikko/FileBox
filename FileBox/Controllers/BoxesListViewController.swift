//
//  BoxesListViewController.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 30.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import UIKit

enum BoxListMode {
    case near
    case top
}

class BoxesListViewController: UIViewController, BoxesListViewModelDelegate {
    @IBOutlet var boxesListTableView: UITableView!
    
    var boxesListViewModel: BoxesListViewModel?
    
    var nearBoxesList = [Box]()
    var topBoxesList = [Box]()
    var mode: BoxListMode = .near
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxesListViewModel = BoxesListViewModel()
        boxesListViewModel?.delefate = self
        
    }
    
    func updateBoxesData(near: [Box], top: [Box]) {
        nearBoxesList = near
        topBoxesList = top
        boxesListTableView.reloadData()
    }
}

extension BoxesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case .near:
            return nearBoxesList.count
        case .top:
            return topBoxesList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = boxesListTableView.dequeueReusableCell(withIdentifier: "BoxListCell", for: indexPath)
        if let cell = cell as? BoxListTableViewCell {
            let box = mode == .near ? nearBoxesList[indexPath.row] : topBoxesList[indexPath.row]
            cell.updateData(box)
        }
        return cell
    }
}

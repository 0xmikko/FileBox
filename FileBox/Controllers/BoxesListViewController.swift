//
//  BoxesListViewController.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 30.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import UIKit
import CoreLocation

enum BoxListMode {
    case near
    case top
}

class BoxesListViewController: UIViewController, BoxesListViewModelDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var modeSegment: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    
    var boxesListViewModel: BoxesListViewModel?
    var location : CLLocation?
    
    var nearBoxesList = [Box]()
    var topBoxesList = [Box]()
    var mode: BoxListMode = .near
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxesListViewModel = BoxesListViewModel()
        boxesListViewModel?.delegate = self
        if let location = location {
            boxesListViewModel?.loadData(location: location)
        }
        
        tableView.dataSource = self
        tableView.separatorColor = UIColor.black
    }
    
    func updateBoxesData(near: [Box], top: [Box]) {
        nearBoxesList = near
        topBoxesList = top
        tableView.reloadData()
    }
    
    @IBAction func modeSwitch(_ sender: Any) {
        switch modeSegment.selectedSegmentIndex {
        case 0:
            mode = .near
            titleLabel.text = "Nearby"
            
        case 1:
            mode = .top
            titleLabel.text = "Top boxes"
            
        default:
            mode = .near
        }
        print(mode, topBoxesList)
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoxListCell", for: indexPath)
        if let cell = cell as? BoxListTableViewCell {
            let box = mode == .near ? nearBoxesList[indexPath.row] : topBoxesList[indexPath.row]
            print("BOX", box)
            cell.updateData(box)
        }
        return cell
    }
}

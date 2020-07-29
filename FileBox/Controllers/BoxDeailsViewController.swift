//
//  BoxContentsViewController.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 24.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import UIKit

struct BoxPref {
    var title: String
    var value: String
}

class BoxDeailsViewController: UIViewController, BoxDetailsViewModelDelegate {
    var boxDetailsViewModel: BoxDetailsViewModel?
    var boxId: String?
    var prefs = [BoxPref]()
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var ipfsHashLabel: UILabel!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoTable.dataSource = self
        
        boxDetailsViewModel = BoxDetailsViewModel()
        boxDetailsViewModel?.delegate = self
        if let id = boxId {
            boxDetailsViewModel?.loadDetails(id: id)
        }
    }
    
    func updateName(_ name: String) {
        nameLabel.text = name
    }
    
    func updateContent(_ content: String) {
        contentLabel.text = content
    }
    
    func updateIPFSHash(_ hash: String) {
        ipfsHashLabel.text = hash
    }
    
    func updatePrefs(_ newPrefs: [BoxPref]) {
        prefs = newPrefs
        infoTable.reloadData()
    }
}

extension BoxDeailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prefs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoxPref", for: indexPath)
        if let cell = cell as? PrefCellView {
            cell.title.text = prefs[indexPath.row].title
            cell.value.text = prefs[indexPath.row].value
        }
        return cell
    }
}

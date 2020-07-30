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
        infoTable.separatorColor = UIColor.black
        
        boxDetailsViewModel = BoxDetailsViewModel()
        boxDetailsViewModel?.delegate = self
        if let id = boxId {
            boxDetailsViewModel?.loadDetails(id: id)
        }
    }
    
    @IBAction func onDownload(_ sender: Any) {
        if let id = boxId {
            boxDetailsViewModel?.downloadFile(id: id)
        }
    }
    
    func saveFile(_ url: URL) {
        // Set the default sharing message.
        //        var url = URL("jjj")
        let documentInteractionController = UIDocumentInteractionController()
        documentInteractionController.url = url
        documentInteractionController.uti = url.uti
        documentInteractionController.presentOpenInMenu(from: view.frame, in: view, animated: true)
//        presentOptionsMenu(from: self, animated: true)
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

extension URL {
    var uti: String {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier ?? "public.data"
    }
}

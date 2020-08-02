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

class BoxDeailsViewController: UIViewController, BoxDetailsViewModelDelegate, UIDocumentInteractionControllerDelegate {
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
//        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let fileURL = documentDirectory.appendingPathComponent("test.jpg")
//        
//        let image = #imageLiteral(resourceName: "ipfs logo")
//        if let imageData = image.jpegData(compressionQuality: 0.5) {
//            do {
//                try imageData.write(to: fileURL)
//                DispatchQueue.main.async {
//                    self.openFileIn(fileURL)
//                }
//            } catch {
//                print("\(error)")
//            }
//        }
    }
    
    func openFileIn(_ url: URL) {
        let documentInteractionController = UIDocumentInteractionController()
        documentInteractionController.delegate = self
        documentInteractionController.url = url
        documentInteractionController.uti = url.uti
        documentInteractionController.presentPreview(animated: true)
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
    
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
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

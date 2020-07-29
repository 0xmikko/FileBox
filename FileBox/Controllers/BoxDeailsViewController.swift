//
//  BoxContentsViewController.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 24.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import UIKit

class BoxDeailsViewController: UIViewController {

    var box : Box?
    @IBOutlet weak var ipfsHash: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Loaded with ", box!.id)

        // Do any additional setup after loading the view.
    }

    func updateDetails (box: Box) {
        ipfsHash.text = box.id
        nameLabel.text = box.name
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

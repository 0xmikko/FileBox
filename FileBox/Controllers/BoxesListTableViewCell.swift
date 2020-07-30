//
//  BoxListTableViewCell.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 30.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import UIKit

class BoxListTableViewCell: UITableViewCell {

    @IBOutlet weak var boxName: UILabel!
    
    @IBOutlet weak var boxParams: UILabel!
    
    @IBOutlet weak var boxDistance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateData(_ box: Box) {
        boxName.text = box.name
        boxParams.text = "Opened: \(box.opened) Downloaded: \(box.downloaded)"
        boxDistance.text = "1.0 km"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
    }
    
}

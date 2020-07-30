//
//  BoxListTableViewCell.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 30.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import MapKit
import UIKit

class BoxListTableViewCell: UITableViewCell {
    @IBOutlet var boxName: UILabel!
    
    @IBOutlet var boxParams: UILabel!
    
    @IBOutlet var boxDistance: UILabel!
    
    var location: CLLocation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateData(_ box: Box) {
        boxName.text = box.name
        boxParams.text = "Opened: \(box.opened) Downloaded: \(box.downloaded)"
        boxDistance.text = box.getHumanDistance()
        location = box.getLocation()
    }
    
    @IBAction func onGoButtonPressed(_ sender: Any) {
        if let location = location {
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
            mapItem.name = boxName.text
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {}
}

//
//  BoxContentsViewController.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 24.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import UIKit

class BoxContentsViewController: UIViewController {

    var box : Box?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Loaded with ", box!.id)

        // Do any additional setup after loading the view.
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

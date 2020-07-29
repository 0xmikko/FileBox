//
//  GPSViewController.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 29.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import UIKit

import ARCL
import SceneKit
import CoreLocation

class GPSViewController: UIViewController {
    var sceneLocationView = SceneLocationView()
    
    @IBOutlet var locView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        sceneLocationView.run()
        locView.addSubview(sceneLocationView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = locView.bounds
    }
    
//
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     
      */
    
    @IBAction func addLoca(_ sender: Any) {

        let location = CLLocation()
        let image = UIImage(named: "globeBoxIcon")!
        
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        
        let cube = SCNSphere(radius: 0.5)        
        cube.firstMaterial?.diffuse.contents = UIColor.red
        
        let boxScene = SCNScene(named: "art.scnassets/box.scn")!
               
               let material = SCNMaterial()
               material.diffuse.contents = UIImage(named: "art.scnassets/box.tga")
               
               let node = boxScene.rootNode.childNode(withName: "Box", recursively: true)!
        
        annotationNode.annotationNode.geometry = node.geometry
        
        sceneLocationView.addLocationNodeForCurrentPosition(locationNode: annotationNode)
        print("OPOPOPOP", sceneLocationView.sceneLocationManager.currentLocation?.coordinate ?? "Nod:")
        print("OPOPOPOP", sceneLocationView.sceneLocationManager.currentLocation?.altitude ?? "Nod:")
        print("OPOPOPOP", sceneLocationView.sceneLocationManager.currentLocation?.course ?? "Nod:")
        }
    }


//
//  ViewController.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 14.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import ARKit
import SceneKit
import UIKit

class ViewController: UIViewController, ARSCNViewDelegate, UIDocumentPickerDelegate {
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [.showFeaturePoints]
        
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//
        // Create a new scene
        
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - UIDocumentPickerDelegate Methods
    
    private func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        if controller.documentPickerMode == UIDocumentPickerMode.import {
            // What should be the line below?
            
            print(url.path!)
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: UIDocumentPickerMode.import)
//         documentPicker.delegate = self
//        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        self.present(documentPicker, animated: true, completion: nil)
//
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            print("HLOO", results)
            guard let result = results.first else { return }
            print(result)
            
             let boxScene = SCNScene(named: "art.scnassets/box.scn")!
            
            
//            let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
            
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "art.scnassets/box.tga")
            //
//            cube.materials = [material]
            
            let node =  boxScene.rootNode.childNode(withName: "Box", recursively: true)!
            
            node.position = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
//            node.geometry = cube
            
            sceneView.scene.rootNode.addChildNode(node)
            sceneView.automaticallyUpdatesLighting = true
            
            print("Q-Q")
            // Set the scene to the view
                    
            
//                    boxNode?.geometry?.materials = [material]
            
//                boxNode?.position = SCNVector3(result.worldTransform.columns.3.x, Float(0), result.worldTransform.columns.3.z)
//                    sceneView.scene.rootNode.addChildNode(boxNode!  )
        }
    }
}

func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    if anchor is ARPlaneAnchor {
        print("Plane detected")
        let planeAncor = anchor as! ARPlaneAnchor
        let plane = SCNPlane(width: CGFloat(planeAncor.extent.x), height: CGFloat(planeAncor.extent.z))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/wood.jpg")
        plane.materials = [material]
        
        let planeNode = SCNNode()
        planeNode.position = SCNVector3(planeAncor.center.x, 0, planeAncor.center.z)
        
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        planeNode.geometry = plane
        
        node.addChildNode(planeNode)
        
        print(planeAncor.center)
    }
}

/*
 // Override to create and configure nodes for anchors added to the view's session.
 func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
 
     return node
 }
 */

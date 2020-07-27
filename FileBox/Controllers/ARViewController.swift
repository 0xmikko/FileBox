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

class ARViewController: UIViewController, ARSCNViewDelegate, UIDocumentPickerDelegate, BoxViewModelDelegate {
    // Control elements
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var mainButton: UIButton!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var filesNearby: UILabel!
    
    var boxViewModel : BoxViewModel!
    
    var readyForLaunch: Bool = false
    var score: Int = 1
    
    @IBAction func onTakeFileButtonPeressed(_ sender: Any) {
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(documentPicker, animated: true, completion: nil)
        mainButton.isEnabled = false
        readyForLaunch = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Adding BoxViewModel
        boxViewModel = BoxViewModel()
        boxViewModel.delegate = self
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [.showFeaturePoints]
        sceneView.automaticallyUpdatesLighting = true
        
        // Configure main button
        mainButton.setTitle("Tap to place for launch", for: .disabled)
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
        if readyForLaunch {
            if let touch = touches.first {
                let screenSize: CGRect = UIScreen.main.bounds
                
                let touchLocation = touch.location(in: sceneView)
                print(touchLocation, screenSize)
                let results = sceneView.hitTest(touchLocation, types: .featurePoint)
                
                guard let result = results.first else { return }
                let position = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
                addBoxToScene(position: position)
                
                mainButton.isEnabled = true
                readyForLaunch = false
                score += 1
                updateScore(newScore: score)
            }
            
        } else {
            if let touch = touches.first {
                let screenSize: CGRect = UIScreen.main.bounds
                
                let touchLocation = touch.location(in: sceneView)
                print(touchLocation, screenSize)
                let results = sceneView.hitTest(touchLocation, options: [SCNHitTestOption.searchMode: 1])
                
                for result in results.filter({ $0.node.name != nil }) {
                    print(result.node.name ?? "HUI")
                    if result.node.name == "Your node name" {
                        // do manipulations
                    }
                }
                
                print(results)
            }
        }
    }
    
    func addBoxToScene(position: SCNVector3) {
        let boxScene = SCNScene(named: "art.scnassets/box.scn")!
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/box.tga")
        
        let node = boxScene.rootNode.childNode(withName: "Box", recursively: true)!
        
        node.name = "Box\(score)"
        node.position = position
        
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func updateScore(newScore: Int) {
        let scoreString = String(format: "%04d", newScore)
        scoreLabel.text = "SCORE: \(scoreString)"
    }
    
    func updateFilesNearby(withNewValue value: Int) {
        filesNearby.text = String(format: "%04d", value)
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        if anchor is ARPlaneAnchor {
//            print("Plane detected")
//            let planeAncor = anchor as! ARPlaneAnchor
//            let plane = SCNPlane(width: CGFloat(planeAncor.extent.x), height: CGFloat(planeAncor.extent.z))
//
//            let material = SCNMaterial()
//            material.diffuse.contents = UIImage(named: "art.scnassets/wood.jpg")
//            plane.materials = [material]
//
//            let planeNode = SCNNode()
//            planeNode.position = SCNVector3(planeAncor.center.x, 0, planeAncor.center.z)
//
//            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
//
//            planeNode.geometry = plane
//
//            node.addChildNode(planeNode)
//
//            print(planeAncor.center)
//        }
//    }
}

extension ARViewController {}

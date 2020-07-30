//
//  ViewController.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 14.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import ARCL
import CoreLocation
import SceneKit
import UIKit

class ARViewController: UIViewController, BoxViewModelDelegate {
    // Control elements
    @IBOutlet var ARView: UIView!
    @IBOutlet var mainButton: UIButton!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var filesNearby: UILabel!
    
   
    var sceneLocationView = SceneLocationView()
    var boxViewModel: BoxViewModel!
    
    var boxDetailsId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding BoxViewModel
        boxViewModel = BoxViewModel()
        boxViewModel.delegate = self
        
        // Set the view's delegate
        sceneLocationView.run()
        ARView.addSubview(sceneLocationView)
        
        sceneLocationView.locationNodeTouchDelegate = self
        
        // Configure main button
        mainButton.setTitle("Tap to place for launch", for: .disabled)
        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(ARViewController.performChange))
        gesture.direction = .left
        self.view.addGestureRecognizer(gesture)

       
        
    }
    
    @objc func performChange() {
        print("GESTURE")
               self.performSegue(withIdentifier: "goBoxesList", sender: nil)
           }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = ARView.bounds
    }
    
    // MARK: - Interface
    
    func updateScore(newScore: Int) {
        let scoreString = String(format: "%04d", newScore)
        scoreLabel.text = "SCORE: \(scoreString)"
    }
    
    func updateFilesNearby(withNewValue value: Int) {
        filesNearby.text = String(format: "%04d", value)
    }
    
    func updateButtonState(state: Bool) {
        mainButton.isEnabled = state
    }
    
    // MARK: - ARSCNViewDelegate
    
//
//        sceneLocationView.addLocationNodeForCurrentPosition(locationNode: annotationNode)
//        print("OPOPOPOP", sceneLocationView.sceneLocationManager.currentLocation?.coordinate ?? "Nod:")
//        print("OPOPOPOP", sceneLocationView.sceneLocationManager.currentLocation?.altitude ?? "Nod:")
//        print("OPOPOPOP", sceneLocationView.sceneLocationManager.currentLocation?.course ?? "Nod:")
//    }
}

// MARK: - UIDocumentPickerDelegate

extension ARViewController: UIDocumentPickerDelegate {
    @IBAction func onUploadButtonPressed(_ sender: Any) {
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.formSheet
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("URL: \(url.lastPathComponent)")
        
        guard let currentLocation = sceneLocationView.sceneLocationManager.currentLocation else { return }
        
        boxViewModel.createBox(url: url, location: currentLocation)
    }
}

// MARK: - Box Controller

extension ARViewController: LNTouchDelegate {
    // Add a box to particular location
    func addBox(id: String, location: CLLocation) {
        let image = UIImage(named: "Cardboard Box")!
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        annotationNode.childNodes.first?.geometry?.name = id
        sceneLocationView.addLocationNodeForCurrentPosition(locationNode: annotationNode)
    }
    
    // Invokes when user tap on Box
    func annotationNodeTouched(node: AnnotationNode) {
        // Do stuffs with the node instance
        if let nodeImage = node.image {
            // Do stuffs with the nodeImage
            // ...
            guard let id = node.geometry?.name else { return }
            boxViewModel.openBox(id: id)
        }
    }
    
    func locationNodeTouched(node: LocationNode) {}
}

// MARK: Router

extension ARViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBoxDetails" {
            let destination = segue.destination as! BoxDeailsViewController
            destination.boxId = boxDetailsId
        }
    }
    
    func showBoxDetails(id: String) {
        boxDetailsId = id
        performSegue(withIdentifier: "goToBoxDetails", sender: self)
    }
    
    func showBoxesList() {
        performSegue(withIdentifier: "goToBoxDetails", sender: self)
    }
}

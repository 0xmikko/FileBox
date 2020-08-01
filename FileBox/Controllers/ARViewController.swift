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
    var locationManager = CLLocationManager()
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
        
        if !hasLocationPermission() {
            let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)

                let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                    //Redirect to Settings app
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                })

            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                alertController.addAction(cancelAction)

                alertController.addAction(okAction)

                self.present(alertController, animated: true, completion: nil)
            }
        
        // Add location manager
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        // Add swipe gesture
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(ARViewController.showBoxesList))
        gesture.direction = .left
        view.addGestureRecognizer(gesture)
    
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        filesNearby.text = String(format: "%03d", value)
    }
    
    func updateButtonState(state: Bool) {
        mainButton.isEnabled = state
    }
    
    // MARK: - ARSCNViewDelegate
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
        guard let id = node.geometry?.name else { return }
        boxViewModel.openBox(id: id)
    }
    
    // Stub for delegate
    func locationNodeTouched(node: LocationNode) {}
}

// MARK: - Location Manager

extension ARViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print(location)
        boxViewModel.onNewCoordinate(location: location)
    }
    
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            }
        } else {
            hasPermission = false
        }

        return hasPermission
    }
}

// MARK: Router

extension ARViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToBoxDetails":
            let destination = segue.destination as! BoxDeailsViewController
            destination.boxId = boxDetailsId
            
        case "goBoxesList":
            let destination = segue.destination as! BoxesListViewController
            destination.location = locationManager.location
            
        default:
            break
        }
    }
    
    func showBoxDetails(id: String) {
        boxDetailsId = id
        performSegue(withIdentifier: "goToBoxDetails", sender: self)
    }
    
    @objc func showBoxesList() {
        performSegue(withIdentifier: "goBoxesList", sender: self)
    }
}

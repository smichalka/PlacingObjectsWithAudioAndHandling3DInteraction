/*
See LICENSE folder for this sample’s licensing information.

Abstract:
UI Actions for the main view controller.
*/

import UIKit
import SceneKit

extension ViewController: UIGestureRecognizerDelegate {
    
    enum SegueIdentifier: String {
        case showObjects
    }
    
    // MARK: - Interface Actions
    
    /// Displays the `VirtualObjectSelectionViewController` from the `addObjectButton` or in response to a tap gesture in the `sceneView`.
    @IBAction func showVirtualObjectSelectionViewController() {
        // Ensure adding objects is an available action and we are not loading another object (to avoid concurrent modifications of the scene).
        guard !addObjectButton.isHidden && !virtualObjectLoader.isLoading else { return }
        
        // Otherwise segue into controls to place objects manually
        statusViewController.cancelScheduledMessage(for: .contentPlacement)
        performSegue(withIdentifier: SegueIdentifier.showObjects.rawValue, sender: addObjectButton)
        

    }
    
    /// Determines if the tap gesture for presenting the `VirtualObjectSelectionViewController` should be used.
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        return virtualObjectLoader.loadedObjects.isEmpty
    }
    
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /// Start the random audio object game
    @IBAction func startRandomAudioGame() {
        //Ensure that we're not loading an object right now
        guard !startRandomAudioButton.isHidden && !virtualObjectLoader.isLoading else {return}
        
        print("starting random audio game")
        
        loadDefaultVirtualObject()
        
        // If no objects place and in autoload, then place virtual objects
        if virtualObjectLoader.loadedObjects.count == 0 && autoPlaceObjects {
            //
            placeObjectsInAir()
            
        }
        
        // Must have at least 1 object to play
        if virtualObjectLoader.loadedObjects.count > 0 {
            
            // Set a random object to the target and start making a sound
            virtualObjectInteraction.targetObject = virtualObjectLoader.loadedObjects.randomElement()
            soundFXManager.playSoundOnObjectLoop(virtualObjectInteraction.targetObject!, availableSounds[soundFXManager.soundFXAssignments["Target"] ?? "Pop"]!)
            
        }
    }
    
    
    
    //SWM: This is currently not working, the object exists, but is not being rendered
    func placeObjectsInAir() {
        print("Placing objects in air")
        let positionVectors = calculateObjectPositions(numObjects: numberOfAutoObjects)
        for positionVector in positionVectors {
            let virtualObject = VirtualObject()
            virtualObject.name = "Box"
            let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.05)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.blue
            virtualObject.geometry = box
            virtualObject.geometry?.materials = [material]
            placeFloatingVirtualObject(virtualObject,positionVector)
            
            //virtualObject.position = positionVector
            //virtualObject.isHidden = false
            virtualObject.shouldUpdateAnchor = false
            sceneView.scene.rootNode.addChildNode(virtualObject)
            
        }
        
            //let virtualObject = VirtualObject.availableObjects.first!
            //virtualObject.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
        //print(virtualObject.modelName)
        //print("name: ", virtualObject.name as Any)

        
            //placeFloatingVirtualObject(virtualObject, x: 0.0 , y: 0.1, z: -0.5)
        
        
        /**
        guard var virtualObject = VirtualObject.availableObjects.first(where: {$0.name == defaultVirtualObjectName}) else  {
            guard var virtualObject = VirtualObject.availableObjects.first else {
                // SWM: This might not be right
                print("Failed to load virtual object with name ", defaultVirtualObjectName, " attempting to make box")
                var virtualObject = VirtualObject()
                virtualObject.name = "Box"
                let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.01)
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.green
                virtualObject.geometry = box
                virtualObject.geometry?.materials = [material]
                return
            }
            return
        }
         */
        
        
    }
    func calculateObjectPositions(numObjects: Int) -> [SCNVector3] {
        
        // Put objects in a line in front of the person at a set distance apart
        let distanceApart = Float(0.3) //distance from middle of next object in meters
        let distanceFromCamera = Float(-0.5) //distance from camera (should be negative to be in front)
        let heightRelativeToCamera = Float( 0.1) // height above camera (or 0 when starting game?)
        var positionVectors = [SCNVector3]()
        
        if numObjects % 2 == 1 {
            // If there are an odd number of objects, put one directly in front
            positionVectors.append(SCNVector3(x: 0.0, y: heightRelativeToCamera, z: distanceFromCamera))
            for i in 1...(numObjects / 2) {
                positionVectors.append(SCNVector3(x: -Float(i) * distanceApart, y: heightRelativeToCamera, z: distanceFromCamera))
                positionVectors.append(SCNVector3(x: Float(i) * distanceApart, y: heightRelativeToCamera, z: distanceFromCamera))
            }
        } else {
            // If there an even number of objects, center them
            for i in 1...(numObjects / 2) {
                positionVectors.append(SCNVector3(x: (-Float(i - 1) * distanceApart) - (distanceApart / Float(2)), y: heightRelativeToCamera, z: distanceFromCamera))
                positionVectors.append(SCNVector3(x: Float(i - 1) * distanceApart + (distanceApart / Float(2)), y: heightRelativeToCamera, z: distanceFromCamera))
            }
            
        }
        
        return positionVectors
        
        
    }
    
    /// - Tag: restartExperience
    func restartExperience() {
        guard isRestartAvailable, !virtualObjectLoader.isLoading else { return }
        isRestartAvailable = false

        statusViewController.cancelAllScheduledMessages()

        virtualObjectLoader.removeAllVirtualObjects()
        addObjectButton.setImage(#imageLiteral(resourceName: "add"), for: [])
        addObjectButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])
        

        resetTracking()

        // Disable restart for a while in order to give the session time to restart.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
            self.upperControlsView.isHidden = false
        }
    }
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    
    // MARK: - UIPopoverPresentationControllerDelegate

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // All menus should be popovers (even on iPhone).
        if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
            popoverController.delegate = self
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
        }
        
        guard let identifier = segue.identifier,
              let segueIdentifer = SegueIdentifier(rawValue: identifier),
              segueIdentifer == .showObjects else { return }
        
        let objectsViewController = segue.destination as! VirtualObjectSelectionViewController
        objectsViewController.virtualObjects = VirtualObject.availableObjects
        objectsViewController.delegate = self
        objectsViewController.sceneView = sceneView
        self.objectsViewController = objectsViewController
        
        // Set all rows of currently placed objects to selected.
        for object in virtualObjectLoader.loadedObjects {
            guard let index = VirtualObject.availableObjects.firstIndex(of: object) else { continue }
            objectsViewController.selectedVirtualObjectRows.insert(index)
        }
    
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        objectsViewController = nil
    }
}

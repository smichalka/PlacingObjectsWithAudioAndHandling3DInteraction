//
//  HomeViewController.swift
//  ARKitInteractionAudio
//
//  Created by Sam Michalka on 12/13/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onStartButton(_ sender: Any){
        //After pressing the start button
        performSegue(withIdentifier: "homeToMainActivity", sender: self)
        
        
    }
    
    @IBAction func onConfigureButton(_ sender: Any){
        // After pressing the configure settings button
    }
}

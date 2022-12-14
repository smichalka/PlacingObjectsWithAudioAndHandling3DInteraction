//
//  SoundFXManager.swift
//  ARKitInteractionAudio
//
//  Created by Sam Michalka on 12/9/22.
//  Copyright © 2022 Apple. All rights reserved.
//
// Abstract:
// Load and manage sound effects


import Foundation
import ARKit

/**
 Loads multiple 'AudioSource's to be able to use them quickly once needed.
 */
class AudioSource : SCNAudioSource {
    
}

extension AudioSource {
    static let availableSounds: [AudioSource] = {
        
  //      let soundsURL = Bundle.main.path(ofType: "aiff", inDirectory: "Sounds")
        let soundsURL = Bundle.main.url(forResource: "Sounds", withExtension: nil)!
        
        //print(soundsURL)
        
        let fileEnumerator = FileManager().enumerator(at: soundsURL, includingPropertiesForKeys: [])!
        
        return fileEnumerator.compactMap { element in
            let url = element as! URL
            
            //TODO: add other possible formats here

            guard url.pathExtension == "aiff"  else { return nil }
            
            print(url)

            return AudioSource(url: url)
        }
    }()
}

class AudioSourceLoader {
    /// Source for audio playback
    var audioSource: SCNAudioSource!
    private(set) var loadedSounds = [AudioSource]()
    
    private(set) var isLoading = false
    
    // MARK: - Loading sound

    /**
     Loads a `AudioSource`  maybe? on a background queue.
    */
    func loadSounds(_ object: AudioSource, loadedHandler: @escaping (AudioSource) -> Void) {
        isLoading = true
        loadedSounds.append(object)
        
        // Load the content into the reference node.
        DispatchQueue.global(qos: .userInitiated).async {
            object.load()
            self.isLoading = false
            loadedHandler(object)
        }
    }

    
    
}

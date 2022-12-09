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

class AudioSourceLoader {
    /// Source for audio playback
    var audioSource: SCNAudioSource!
    
    private(set) var isLoading = false
    
    
}

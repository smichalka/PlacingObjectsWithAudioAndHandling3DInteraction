//
//  SoundFXManager.swift
//  ARKitInteractionAudio
//
//  Created by Sam Michalka on 12/9/22.
//  Copyright © 2022. All rights reserved.
//
// Abstract:
// Load and manage sound effects


import Foundation
import ARKit

/**
 Loads multiple 'AudioSource's to be able to use them quickly once needed.
 */

class SoundFXManager{
    
    // MARK: - Update object sound
    /// - Tag: ToggleObjectSound
    func toggleObjectSound(_ object: VirtualObject,_ audioSource : AudioSource) {
        if ((object.audioPlayers.isEmpty)){
            // if nothing is playing on object
            // play indefinitely
            audioSource.loops = true
            object.addAudioPlayer(SCNAudioPlayer(source: audioSource))
        } else {
            // if playing, remove all audio
            object.removeAllAudioPlayers()
        }
    }
     /// - Tag: PlaySoundOnObjectOnce
     func playSoundOnObjectOnce(_ object: VirtualObject, _ audioSource : AudioSource){
     audioSource.loops = false
     object.removeAllAudioPlayers()
     object.addAudioPlayer(SCNAudioPlayer(source: audioSource))
     
     }
    
    /// - Tag: PlaySoundOnObjectLoop
    func playSoundOnObjectLoop(_ object: VirtualObject, _ audioSource : AudioSource){
    audioSource.loops = true
    object.removeAllAudioPlayers()
    object.addAudioPlayer(SCNAudioPlayer(source: audioSource))
    
    }
    
    
    
}

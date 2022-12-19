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
    
    func listAvailableSounds() -> [String] {
        print("Listing available sounds")
        var availableSounds : [String] = []
        let soundsURL = Bundle.main.url(forResource: "Sounds", withExtension: nil)!
        print(soundsURL)
        
        let fileEnumerator = FileManager().enumerator(at: soundsURL, includingPropertiesForKeys: [])!
        
        availableSounds = fileEnumerator.compactMap { element in
            let url = element as! URL
            
            //TODO: add other possible formats here
            if url.pathExtension == "aiff" || url.pathExtension == "mp3" {
                //availableSounds.append(url.deletingPathExtension().lastPathComponent)
                print("adding: : ")
                print(url.deletingPathExtension().lastPathComponent)
                return String(url.deletingPathExtension().lastPathComponent)
            } else {
                print("nil")
                return nil
            }
        }
        return availableSounds.sorted()
    }
    
    
    func listAvailableSoundsOld() -> [String] {
        print("Listing available sounds")
//        var availableSounds : [String] = []
        let soundsURL = Bundle.main.url(forResource: "Sounds", withExtension: nil)!
        print(soundsURL)
        
        let fileEnumerator = FileManager().enumerator(at: soundsURL, includingPropertiesForKeys: [])!
        
        return fileEnumerator.compactMap { element in
            let url = element as! URL
            
            //TODO: add other possible formats here
            if url.pathExtension == "aiff" || url.pathExtension == "mp3" {
                //availableSounds.append(url.deletingPathExtension().lastPathComponent)
                print("adding: : ")
                print(url.deletingPathExtension().lastPathComponent)
                return String(url.deletingPathExtension().lastPathComponent)
            } else {
                print("nil")
                return nil
            }
        }
    }
    
    
    
    // MARK: - Update object sound
    /// - Tag: ToggleObjectSound
    func toggleObjectSound(_ object: VirtualObject,_ audioSource : SCNAudioSource) {
        if ((object.audioPlayers.isEmpty)){
            // if nothing is playing on object
            //var audioSource: SCNAudioSource!
            //audioSource = SCNAudioSource(fileNamed: "Track 16.mp3")!
            // play indefinitely
            audioSource.loops = true
            object.addAudioPlayer(SCNAudioPlayer(source: audioSource))
        } else {
            // if playing, remove all audio
            object.removeAllAudioPlayers()
        }
    }
    /// - Tag: PlaySoundOnObject
    func playSoundOnObjectOnce(_ object: VirtualObject, _ soundType : String){
        //audioSource = loadedSounds.first
        //audioSource.loops = false
        print(soundType)
        object.removeAllAudioPlayers()
        //object.addAudioPlayer(SCNAudioPlayer(source: audioSource))
        let audioSource = SCNAudioSource(fileNamed: "Frog.aiff")!
        // play indefinitely
        audioSource.loops = true
        object.addAudioPlayer(SCNAudioPlayer(source: audioSource))
        
    }
    /**
     func playSoundOnObjectOnce(_ object: VirtualObject, _ audioSource : SCNAudioSource){
     audioSource.loops = false
     object.removeAllAudioPlayers()
     object.addAudioPlayer(SCNAudioPlayer(source: audioSource))
     
     }
     */
    
    
    
}

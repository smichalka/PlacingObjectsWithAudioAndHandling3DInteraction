//
//  AudioSource.swift
//  ARKitInteractionAudio
//
//  Created by Sam Michalka on 12/15/22.
//  Copyright © 2022. All rights reserved.
//

import Foundation
import ARKit

/**
 Loads multiple 'AudioSource's to be able to use them quickly once needed.
 */


class AudioSource : SCNAudioSource {
}

extension AudioSource {
    
    // Create a dictionary to store the file names and the audio source
    static let availableSoundsDict: [String: AudioSource] = {
        var availableSoundsDict : [String: AudioSource] = [:]
        // Location of audio sound files available as options
        let soundsURL = Bundle.main.url(forResource: "Sounds", withExtension: nil)!
        let fileEnumerator = FileManager().enumerator(at: soundsURL, includingPropertiesForKeys: [])!
        var fileURLs : [URL] = []
        // Make compact map of the URLs (there is probably a more efficient way to do this)
        fileURLs = fileEnumerator.compactMap { element in
            let url = element as! URL
            if url.pathExtension == "aiff" || url.pathExtension == "mp3" {
                //print("adding: a url ")
                return url
            } else {
                //print("nil")
                return nil
            }
        }
        for url in fileURLs {
            availableSoundsDict[url.deletingPathExtension().lastPathComponent] = AudioSource(url: url)
        }
        return availableSoundsDict
        
    }()
}

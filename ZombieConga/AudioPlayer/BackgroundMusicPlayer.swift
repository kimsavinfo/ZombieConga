//
//  BackgroundMusicPlayer.swift
//  ZombieConga
//
//  Created by Kim SAVAROCHE on 12/08/2017.
//  Copyright © 2017 Kim SAVAROCHE. All rights reserved.
//

import AVFoundation

class BackgroundMusicPlayer {
    var musicPlayer: AVAudioPlayer!
    
    func play(filename: String) {
        let resourceUrl = Bundle.main.url(forResource:
            filename, withExtension: nil)
        guard let url = resourceUrl else {
            print("Could not find file: \(filename)")
            return
        }
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOf: url)
            musicPlayer.numberOfLoops = -1
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        } catch {
            print("Could not create audio player!")
            return
        }
    }
    
    func stop() {
        musicPlayer.stop()
    }
}

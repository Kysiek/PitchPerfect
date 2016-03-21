//
//  PitchPerfectAPI.swift
//  Pitch Perfect
//
//  Created by Krzysztof Maciążek on 20/03/16.
//  Copyright © 2016 kysieksoftware. All rights reserved.
//

import Foundation
import AVFoundation

class PitchPerfectAPI {
    
    private var audioPlayer: AVAudioPlayer!
    private var audioEngine: AVAudioEngine!
    private var audioFile: AVAudioFile!
    private var echoAudioPlayer: AVAudioPlayer!
    private var reverbAudioPlayers: [AVAudioPlayer]!
    private var audioPlayerNode: AVAudioPlayerNode?
    private var playMode: PlayMode
    
    private var isPaused = false;
    
    required init(recorderAudio: RecordedAudio) {
        audioPlayer = try! AVAudioPlayer.init(contentsOfURL: recorderAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        echoAudioPlayer = try! AVAudioPlayer.init(contentsOfURL: recorderAudio.filePathUrl)
        echoAudioPlayer.volume = Config.AudioPlayerConstants.VOLUME_FOR_ECHO
        
        let numOfReverbAudioPlayers = Config.AudioPlayerConstants.REVERB_AUDIO_PLAYERS
        reverbAudioPlayers = [AVAudioPlayer]()
        for i in 0..<numOfReverbAudioPlayers {
            reverbAudioPlayers.append(try! AVAudioPlayer.init(contentsOfURL: recorderAudio.filePathUrl))
            reverbAudioPlayers[i].volume = Config.AudioPlayerConstants.calculateVolumeInReverbPlayForPlayerIndex(i, totalNumOfReverbPlayers: numOfReverbAudioPlayers)
        }
        
        
        echoAudioPlayer = try! AVAudioPlayer.init(contentsOfURL: recorderAudio.filePathUrl)
        echoAudioPlayer.volume = Config.AudioPlayerConstants.VOLUME_FOR_ECHO
        
        audioEngine = AVAudioEngine()
        
        self.audioFile = try! AVAudioFile(forReading: recorderAudio.filePathUrl)
        
        playMode = .DiffRate
    }
    
    func playSnailEffect() {
        startPlayingWithSpeed(Config.AudioPlayerConstants.SNAIL_EFFECT_RATE)
        playMode = .DiffRate
    }
    
    func playRabbitEffect() {
        startPlayingWithSpeed(Config.AudioPlayerConstants.RABBIT_EFFECT_RATE)
        playMode = .DiffRate
    }
    
    func playChipmuntEffect() {
        playAudioWithVariablePitch(Config.AudioPlayerConstants.CHIPMUNK_EFFECT_PITCH)
        playMode = .Pitch
    }
    
    func playDarthVaderEffect() {
        playAudioWithVariablePitch(Config.AudioPlayerConstants.DARTH_VADER_EFFECT_PITCH)
        playMode = .Pitch
    }
    
    func playEchoEffect() {
        resetAnyPlaying()
        
        let playAtTime = generatePlayTimeForDelay(Config.AudioPlayerConstants.DELAY_FOR_ECHO, forDevice: echoAudioPlayer)
        
        audioPlayer.play()
        echoAudioPlayer.playAtTime(playAtTime)
        playMode = .Echo
    }
    
    func playReverbEffect() {
        let delay = Config.AudioPlayerConstants.DELAY_FOR_REVERB
        for i in 0..<reverbAudioPlayers.count {
            let currentDelay = generatePlayTimeForDelay(delay * NSTimeInterval(i), forDevice: reverbAudioPlayers[i])
            reverbAudioPlayers[i].playAtTime(currentDelay)
        }
        playMode = .Reverb
    }
    
    func pausePlaying() {
        isPaused = true;
        switch playMode {
        case .DiffRate:
            audioPlayer.stop()
        case .Pitch:
            audioPlayerNode?.pause()
        case .Echo:
            audioPlayer.stop()
            echoAudioPlayer.stop()
        case .Reverb:
            for i in 0..<reverbAudioPlayers.count {
                reverbAudioPlayers[i].stop()
            }
        }
    }
    
    func resumePlaying() {
        isPaused = false;
        switch playMode {
        case .DiffRate:
            audioPlayer.play()
        case .Pitch:
            audioPlayerNode?.play()
        case .Echo:
            audioPlayer.play()
            echoAudioPlayer.play()
        case .Reverb:
            for i in 0..<reverbAudioPlayers.count {
                reverbAudioPlayers[i].play()
            }
        }
    }
    
    func isPlaying() -> Bool {
        return !isPaused
    }
    
    func getDuration() -> String {
        return String(format: "%.2f", Float(audioPlayer.duration))
    }
    
    private func startPlayingWithSpeed(speedRate: Float) {
        resetAnyPlaying()
        
        audioPlayer.rate = speedRate
        audioPlayer.play()
    }
    
    private func playAudioWithVariablePitch(pitch: Float) {
        resetAnyPlaying()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode!)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode!, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode?.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        audioPlayerNode?.play()
    }
    
    private func resetAnyPlaying() {
        stopAndRestartAudioPlayers()
        stopAndRestartAudioEngine()
    }
    
    private func stopAndRestartAudioPlayers() {
        switch playMode {
        case .DiffRate, .Pitch:
            audioPlayer.stop()
            audioPlayer.currentTime = 0.0
        case .Echo:
            audioPlayer.stop()
            audioPlayer.currentTime = 0.0
            echoAudioPlayer.stop()
            echoAudioPlayer.currentTime = 0.0
        case .Reverb:
            for i in 0..<reverbAudioPlayers.count {
                reverbAudioPlayers[i].stop()
                reverbAudioPlayers[i].currentTime = 0.0
            }
        }
    }
    
    private func stopAndRestartAudioEngine() {
        if playMode == .Pitch {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    private func generatePlayTimeForDelay(delay: Double, forDevice: AVAudioPlayer) -> NSTimeInterval {
        let delayInNSTimeInterval: NSTimeInterval = delay
        return forDevice.deviceCurrentTime + delayInNSTimeInterval
    }
    
}
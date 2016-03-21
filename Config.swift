//
//  Config.swift
//  Pitch Perfect
//
//  Created by Krzysztof Maciążek on 20/03/16.
//  Copyright © 2016 kysieksoftware. All rights reserved.
//

import Foundation

struct Config {
    struct StoryboardConstants {
        static let SHOW_PLAY_SOUNDS_SCENE_SEGUE_ID = "stopRecordingSegue"
        static let TAP_TO_RECORD_TITLE = "Tap to record"
        static let RECORDING_TITLE = "Recording..."
    }
    struct AudioFileConstants {
        static let RECORDED_FILE_NAME = "my_sound.wav"
    }
    struct AudioPlayerConstants {
        static let SNAIL_EFFECT_RATE: Float = 0.5
        static let RABBIT_EFFECT_RATE: Float = 1.5
        static let CHIPMUNK_EFFECT_PITCH: Float = 1000.0
        static let DARTH_VADER_EFFECT_PITCH: Float = -1000.0
        static let DELAY_FOR_ECHO = 0.2
        static let DELAY_FOR_REVERB = 0.02
        static let VOLUME_FOR_ECHO: Float = 0.5
        static let REVERB_AUDIO_PLAYERS = 10
        
        static func calculateVolumeInReverbPlayForPlayerIndex(index: Int, totalNumOfReverbPlayers: Int) -> Float {
            return Float(pow(Double(M_E), -Double(index)/Double(totalNumOfReverbPlayers/2)))
        }
    }
}
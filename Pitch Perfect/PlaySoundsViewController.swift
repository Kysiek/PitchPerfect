//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Krzysztof Maciążek on 19/03/16.
//  Copyright © 2016 kysieksoftware. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var receivedAudio: RecordedAudio!
    
    var pitchPerfectAPI: PitchPerfectAPI!
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pitchPerfectAPI = PitchPerfectAPI(recorderAudio: receivedAudio)
        
    }

    override func viewWillAppear(animated: Bool) {
        setDurationLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSlow(sender: AnyObject) {
        pitchPerfectAPI.playSnailEffect()
    }
    @IBAction func playFast(sender: AnyObject) {
        pitchPerfectAPI.playRabbitEffect()
    }

    @IBAction func playChipmunk(sender: AnyObject) {
        pitchPerfectAPI.playChipmuntEffect()
    }
    @IBAction func playDarthVader(sender: AnyObject) {
        pitchPerfectAPI.playDarthVaderEffect()
    }
    @IBAction func playEcho(sender: AnyObject) {
        pitchPerfectAPI.playEchoEffect()
    }
    
    @IBAction func playReverb(sender: AnyObject) {
        pitchPerfectAPI.playReverbEffect()
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        var nameOfImage: String = "resumeBlue"
        if pitchPerfectAPI.isPlaying() {
            pitchPerfectAPI.pausePlaying()
        } else {
            nameOfImage = "pauseBlue"
            pitchPerfectAPI.resumePlaying()
        }
        startStopButton.setImage(UIImage(named: nameOfImage), forState: .Normal)
    }
    
    private func setDurationLabel() {
        durationLabel.text = "Duration: \(pitchPerfectAPI.getDuration()) s"
    }
}

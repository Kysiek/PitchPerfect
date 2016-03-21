//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Krzysztof Maciążek on 18/03/16.
//  Copyright © 2016 kysieksoftware. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController {

    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        readyForRecordingState()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Config.StoryboardConstants.SHOW_PLAY_SOUNDS_SCENE_SEGUE_ID {
            let playSoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsViewController.receivedAudio = data
        }
    }
    
    @IBAction func recordAudio(sender: AnyObject) {
        recordingState()
        if let filePath = createFilePath() {
            setAudioSessionToPlayAndRecord()
            audioRecorder = try! AVAudioRecorder(URL: filePath, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }
    
    @IBAction func stopRecordingAudio(sender: AnyObject) {
        if audioRecorder.recording {
            audioRecorder.stop()
            setAudioSessionToInactive()
        }
    }
    
    private func readyForRecordingState() {
        stopRecordingButton.hidden = true
        recordingLabel.text = Config.StoryboardConstants.TAP_TO_RECORD_TITLE
        recordingButton.enabled = true
    }
    
    private func recordingState() {
        stopRecordingButton.hidden = false
        recordingLabel.text = Config.StoryboardConstants.RECORDING_TITLE
        recordingButton.enabled = false
    }
    
    private func createFilePath() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        return documentDirectory.URLByAppendingPathComponent(Config.AudioFileConstants.RECORDED_FILE_NAME)
    }
    
    private func setAudioSessionToPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! session.setActive(true)
    }
    private func setAudioSessionToInactive() {
        try! AVAudioSession.sharedInstance().setActive(false)
    }
}

extension RecordSoundViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            performSegueWithIdentifier(Config.StoryboardConstants.SHOW_PLAY_SOUNDS_SCENE_SEGUE_ID, sender: RecordedAudio(filePathUrl: recorder.url,title: recorder.url.lastPathComponent!))
        }
    }
}


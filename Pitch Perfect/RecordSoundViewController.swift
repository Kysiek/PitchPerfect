//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Krzysztof Maciążek on 18/03/16.
//  Copyright © 2016 kysieksoftware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        readyForRecordingState()
    }
    
    @IBAction func didTapRecordingButton(sender: AnyObject) {
        recordingState()
    }
    @IBAction func didTapStopRecordingButton(sender: AnyObject) {
        
    }
    
    
    private func readyForRecordingState() {
        stopRecordingButton.hidden = true
        recordingLabel.hidden = true
        recordingButton.enabled = true
    }
    
    private func recordingState() {
        stopRecordingButton.hidden = false
        recordingLabel.hidden = false
        recordingButton.enabled = false
    }
    

}


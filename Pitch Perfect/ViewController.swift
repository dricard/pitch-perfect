//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Denis Ricard on 2015-09-16.
//  Copyright © 2015 Hexaedre. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        // TODO: record the user's voice
        print("in audioRecord")
        recordingLabel.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
    }

    @IBAction func stopRecording(sender: UIButton) {
        print("in stopRecording")
        recordingLabel.hidden = true
        stopButton.hidden = true
        recordButton.enabled = true
    }
    
    
    @IBOutlet weak var recordingLabel: UILabel!
}


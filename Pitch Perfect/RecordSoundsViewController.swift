//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Denis Ricard on 2015-09-16.
//  Copyright © 2015 Hexaedre. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeLabel: UILabel!
    @IBOutlet weak var pauseLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    
    let doDebug = false
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    enum RecordingMode {
        case Recording
        case Paused
        init() {
            self = .Recording
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        if doDebug { print("in viewWillAppear") }
        waitingTapToRecord()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        if doDebug { print("in audioRecord") }
        recordingInterface(.Recording)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        if doDebug { print(filePath) }
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        do {
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        } catch {
            print("could not set output to speaker")
        }
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
   }

    func waitingTapToRecord() {
        if doDebug { print("in waitingTapToRecord") }
        recordButton.enabled = true
        recordingLabel.text = "Tap to record"
        stopButton.hidden = true
        resumeButton.hidden = true
        pauseButton.hidden = true
        resumeLabel.hidden = true
        pauseLabel.hidden = true
        stopLabel.hidden = true
    }
    
    func recordingInterface(mode: RecordingMode) {
        stopButton.hidden = false
        resumeButton.hidden = false
        pauseButton.hidden = false
        resumeLabel.hidden = false
        pauseLabel.hidden = false
        stopLabel.hidden = false
        recordButton.enabled = false
        switch mode {
        case .Recording:
            recordingLabel.text = "Recording"
            resumeButton.enabled = false
            pauseButton.enabled = true
        case .Paused:
            resumeButton.enabled = true
            pauseButton.enabled = false
            recordingLabel.text = "Recording paused"
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        // if finished recording successfully we process. Flag is true in that case
        if flag {
            recordedAudio = RecordedAudio.init(path: recorder.url, title: recorder.url.lastPathComponent!)

            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            if doDebug { print("Recording was not successful!") }
            waitingTapToRecord()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        if doDebug { print("in stopRecording") }

        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        recordingInterface(.Paused)
        audioRecorder.pause()
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        recordingInterface(.Recording)
        audioRecorder.record()
    }
}


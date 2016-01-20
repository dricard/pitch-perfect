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
        case Waiting
        case Recording
        case Paused
        init() {
            self = .Waiting
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if doDebug { print("in viewWillAppear") }
        recordingInterface(.Waiting)
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

    func showAndHideRecordingInterface(hide: Bool) {
        if doDebug { print("in waitingTapToRecord") }
        // hide = true to hide the recording interface (and enable the 'tap to record' button)
        // hide = false to show the recording interface (and disable the 'tap to record' button)
        stopButton.hidden = hide
        resumeButton.hidden = hide
        pauseButton.hidden = hide
        resumeLabel.hidden = hide
        pauseLabel.hidden = hide
        stopLabel.hidden = hide
        recordButton.enabled = hide
   }
    
    func recordingInterface(mode: RecordingMode) {
        switch mode {
        case .Waiting:
            showAndHideRecordingInterface(true)
            recordingLabel.text = "Tap to record"
        case .Recording:
            showAndHideRecordingInterface(false)
            recordingLabel.text = "Recording"
            resumeButton.enabled = false
            pauseButton.enabled = true
        case .Paused:
            showAndHideRecordingInterface(false)
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
            recordingInterface(.Waiting)
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


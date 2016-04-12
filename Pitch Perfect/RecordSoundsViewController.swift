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
    
    // MARK: Properties
    
    // set doDebug to true to print various states to help debuging
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

    // MARK: Outlets
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeLabel: UILabel!
    @IBOutlet weak var pauseLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    
    //MARK: Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        if doDebug { print("in viewWillAppear") }
        recordingInterface(.Waiting)
    }

    // MARK: User actions
    
    // User pressed the record button
    @IBAction func recordAudio(sender: UIButton) {
        
        if doDebug { print("in audioRecord") }
        // First set the interface to recording
        recordingInterface(.Recording)
        // get a path to the documents' directory
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        // set the name, if we wanted to save more than one recording we'd have to
        // modify this
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        if doDebug { print(filePath) }
        
        // start a AVAudioSession
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
    
    // MARK: Utilities methods
    
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
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

}


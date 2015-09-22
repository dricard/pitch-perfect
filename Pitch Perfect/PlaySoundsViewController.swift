//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Denis Ricard on 2015-09-17.
//  Copyright © 2015 Hexaedre. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    let doDebug = false
    
    var myAudioPlayer : AVAudioPlayer!
    var noError : Bool = false
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       do {
            myAudioPlayer = try AVAudioPlayer.init(contentsOfURL: receivedAudio.filePathUrl)
            myAudioPlayer.enableRate = true
            noError = true
        } catch {
            print("ERR: Failed to instantiate myAudioPlayer in PlaySoundsViewController")
        }
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func playAudioRate(theRate: Float) {
        if theRate >= 0.5 && theRate <= 2.0 {
            myAudioPlayer.stop()
            audioEngine.stop()
            audioEngine.reset()
            
            myAudioPlayer.rate = theRate
            myAudioPlayer.currentTime = 0.0
            myAudioPlayer.play()
        }
    }
    
    func playAudioPitch(thePitch: Float) {
        if thePitch >= -2400 && thePitch <= 2400 {
            
            if doDebug { print("In PlayAudioPitch with parameter \(thePitch).") }
            // Stop and reset everything
            myAudioPlayer.stop()
            audioEngine.stop()
            audioEngine.reset()
            
            // Create player nodes
            let pitchPlayer = AVAudioPlayerNode()
            audioEngine.attachNode(pitchPlayer)

            // create pitch effect node
            let timePitch = AVAudioUnitTimePitch()
            timePitch.pitch = thePitch
            audioEngine.attachNode(timePitch)
            
            audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
            audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
            
            pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
            try! audioEngine.start()
            
            pitchPlayer.play()

            
        } else {
            print("ERR: input value for pitch [\(thePitch)] is out of bounds (-2400..+2400)")
        }
    }
    

    @IBAction func playSlow(sender: UIButton) {
        if noError {
            if doDebug { print("playing slow...") }
            playAudioRate(0.5)
         } else {
            print("ERR: trying to play a file sound while failed to load.")
        }
        
    }

    @IBAction func playChipmunk(sender: UIButton) {
        if noError {
            if doDebug { print("playing chipmunk...") }
            playAudioPitch(1000)
        } else {
            print("ERR: trying to play a file sound while failed to load.")
        }
    }
    
    @IBAction func playDarkVader(sender: UIButton) {
        if noError {
            if doDebug { print("playing darkvader...") }
            playAudioPitch(-900)
        } else {
            print("ERR: trying to play a file sound while failed to load.")
        }
    }
    
    @IBAction func playFast(sender: UIButton) {
        if noError {
            if doDebug { print("playing fast...") }
            playAudioRate(2.0)
        } else {
            print("ERR: trying to play a file sound while failed to load.")
        }
       
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        myAudioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        if doDebug { print("Playback stopped") }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

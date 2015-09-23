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
    
    enum EffectMode {
        case Pitch
        case Reverb
    }
    
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

    override func viewWillDisappear(animated: Bool) {
        resetPlayer()
    }
    
    func resetPlayer() {
        myAudioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioRate(theRate: Float) {
        if theRate >= 0.5 && theRate <= 2.0 {
            resetPlayer()
            
            myAudioPlayer.rate = theRate
            myAudioPlayer.currentTime = 0.0
            myAudioPlayer.play()
        }
    }
   
    func playWithEffect(mode: EffectMode, effectParameter: Float) {
 
        // Stop and reset everything
        resetPlayer()
        
        // Create player nodes
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // create effect node
        // I searched the documentation and examples on the internet for the reverb effect
        // I cannot put the audioEngine.attachNode(effect) line and those following
        // outside the switch statement because they're of different types depending on
        // the mode: effect for Pitch is of type AVAudioUnitTimeEffect while
        // effect for Reverb is of type AVAudioUnitEffect
        switch mode {
        case .Pitch:
            let effect = AVAudioUnitTimePitch()
            effect.pitch = effectParameter
            audioEngine.attachNode(effect)
            let inputFormat = effect.inputFormatForBus(0)
            audioEngine.connect(audioPlayerNode, to: effect, format: inputFormat)
            audioEngine.connect(effect, to: audioEngine.outputNode, format: inputFormat)
       case .Reverb:
            let effect = AVAudioUnitReverb()
            effect.loadFactoryPreset(.Cathedral)
            effect.wetDryMix = 50.0
            audioEngine.attachNode(effect)
            let inputFormat = effect.inputFormatForBus(0)
            audioEngine.connect(audioPlayerNode, to: effect, format: inputFormat)
            audioEngine.connect(effect, to: audioEngine.outputNode, format: inputFormat)
        }
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
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
            playWithEffect(.Pitch, effectParameter: 1000)
        } else {
            print("ERR: trying to play a file sound while failed to load.")
        }
    }
    
    @IBAction func playDarkVader(sender: UIButton) {
        if noError {
            if doDebug { print("playing darkvader...") }
            playWithEffect(.Pitch, effectParameter: -600)
        } else {
            print("ERR: trying to play a file sound while failed to load.")
        }
    }
    
    
    @IBAction func playReverb(sender: UIButton) {
        if noError {
            if doDebug { print("playing reverb...") }
            playWithEffect(.Reverb, effectParameter: 0)
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
        resetPlayer()
        if doDebug { print("Playback stopped") }
    }
}

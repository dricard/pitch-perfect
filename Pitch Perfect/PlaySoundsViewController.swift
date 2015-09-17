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

    var myAudioPlayer : AVAudioPlayer!
    var noError : Bool = false
    
    func playAudio(theRate: Float) {
        if theRate >= 0.5 && theRate <= 2.0 {
            myAudioPlayer.rate = theRate
            myAudioPlayer.currentTime = 0.0
            myAudioPlayer.stop()
            myAudioPlayer.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
            let fileURL = NSURL(fileURLWithPath: filePath)
            do {
                myAudioPlayer = try AVAudioPlayer.init(contentsOfURL: fileURL)
                myAudioPlayer.enableRate = true
                noError = true
            } catch {
                print("ERR: Failed to instantiate myAudioPlayer in PlaySoundsViewController")
            }
        } else {
            print("ERR: Failed to get valid file path to sound file")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlow(sender: UIButton) {
        if noError {
            print("playing slow...")
            playAudio(0.5)
         } else {
            print("ERR: trying to play a file sound while failed to load.")
        }
        
    }

    @IBAction func playFast(sender: UIButton) {
        if noError {
            print("playing fast...")
            playAudio(2.0)
        } else {
            print("ERR: trying to play a file sound while failed to load.")
        }
       
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        myAudioPlayer.stop()
        print("Playback stopped")
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

//
//  PlaySoundsViewController.swift
//  Pitch Purrfect
//
//  Created by David Fierstein on 3/16/15.
//  Copyright (c) 2015 davidiad. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var player : AVAudioPlayer! = nil
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    // Add outlets for buttons so their backgrounds can be set in code
    @IBOutlet weak var slowbutton: UIButton!
    @IBOutlet weak var fastbutton: UIButton!
    @IBOutlet weak var chipmunkbutton: UIButton!
    @IBOutlet weak var vaderbutton: UIButton!
    @IBOutlet weak var reverbbutton: UIButton!
    @IBOutlet weak var echobutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        player.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSoundSlowly(sender: UIButton) {
        playSound(0.5)
        sender.setImage(UIImage(named: "slowbuttonTapped"), forState: UIControlState.Normal)
    }

    @IBAction func playSoundFast(sender: UIButton) {
        playSound(2.0)
        sender.setImage(UIImage(named: "fastbuttonTapped"), forState: UIControlState.Normal)
    }

    @IBAction func stopButton(sender: UIButton) {
        player.stop()
        audioEngine.stop()
        resetButtonImages()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1200)
        sender.setImage(UIImage(named: "chipmunkTapped"), forState: UIControlState.Normal)
    }

    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1200)
        sender.setImage(UIImage(named: "darthvaderTapped"), forState: UIControlState.Normal)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioWithReverb(100.0)
        sender.setImage(UIImage(named: "reverbTapped"), forState: UIControlState.Normal)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioWithEcho(50.0)
        sender.setImage(UIImage(named: "echoTapped"), forState: UIControlState.Normal)
    }
    
    func resetButtonImages() {
        slowbutton.setImage(UIImage(named: "slowbutton"), forState: UIControlState.Normal)
        fastbutton.setImage(UIImage(named: "fastbutton"), forState: UIControlState.Normal)
        chipmunkbutton.setImage(UIImage(named: "chipmunkbutton"), forState: UIControlState.Normal)
        vaderbutton.setImage(UIImage(named: "darthvaderbutton"), forState: UIControlState.Normal)
        reverbbutton.setImage(UIImage(named: "reverbbutton"), forState: UIControlState.Normal)
        echobutton.setImage(UIImage(named: "echobutton"), forState: UIControlState.Normal)
    }
    
    // helper function to stop the current sound playing and reset the button images
    func resetAudio() {
        resetButtonImages()
        player.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playSound(soundRate: Float) {
        resetAudio()
        player.rate = soundRate
        player.currentTime = 0.0
        player.play()
    }

    func playAudioWithVariablePitch(pitch: Float) {
        resetAudio()
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudioWithReverb(amount: Float) {
        resetAudio()
        var effect = AVAudioUnitReverb()
        effect.wetDryMix = amount
        audioEngine.attachNode(effect)
        playAudioWithEffect(effect)
    }
    
    func playAudioWithEcho(amount: Float) {
        resetAudio()
        var effect = AVAudioUnitDelay()
        effect.wetDryMix = amount
        audioEngine.attachNode(effect)
        playAudioWithEffect(effect)
    }
    
    func playAudioWithEffect(effect: AVAudioUnitEffect) {
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

}

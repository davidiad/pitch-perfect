//
//  RecordSoundsViewController.swift
//  Pitch Purrfect
//
//  Created by David Fierstein on 3/13/15.
//  Copyright (c) 2015 davidiad. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        recordingLabel.text = "Tap to record"
        recordingLabel.hidden = false
        stopButton.hidden = true
        pauseButton.hidden = true
        recordButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingLabel.text = "Recording in Progress"
        recordingLabel.hidden = false
        stopButton.hidden = false
        pauseButton.hidden = false
        pauseButton.enabled = true
        stopButton.enabled = true
        recordButton.enabled = false
        
        // if the audioRecorder does not exist, set up for a new recording
        // otherwise, audioRecorder exists already, and we simply resume, and add to, the previous recording
        if audioRecorder == nil {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
            var currentDateTime = NSDate();
            var formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            var recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
            var pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            // set up audio session
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error : nil)
            
            // Inititialize and prepare the recorder
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(audioRecorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: audioRecorder.url, title: audioRecorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        } else {
            println("Couldn't find Segue")
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        recordingLabel.hidden = true
        stopButton.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    @IBAction func pauseAudio(sender: UIButton) {
        audioRecorder.pause()
        stopButton.enabled = false
        recordButton.enabled = true
        pauseButton.enabled = false
        recordingLabel.text = "Tap microphone to resume recording"
    }
}


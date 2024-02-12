//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mahesh Adhikari on 10/14/2023.
//  Copyright © 2023 Mahesh Adhikari. All rights reserved.
//


import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {


    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    var audioRecorder: AVAudioRecorder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(recordingEnabled: true)
        
    }
    
    @IBAction func recordAudio(_ sender: UIButton) {
        configureUI(recordingEnabled: false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        configureUI(recordingEnabled: true)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundViewController = segue.destination as! PlaySoundsViewController
            let recordedSoundURL = sender as! URL
            playSoundViewController.recordedAudioURL = recordedSoundURL
        }
    }
    
    func configureUI( recordingEnabled: Bool) {
        stopRecordingButton.isEnabled = !recordingEnabled
        recordButton.isEnabled = recordingEnabled
        if recordingEnabled {
            recordingLabel.text = "Tap to Record"
        } else {
            recordingLabel.text = "Recording in progress"
        }
        
    }
    


}

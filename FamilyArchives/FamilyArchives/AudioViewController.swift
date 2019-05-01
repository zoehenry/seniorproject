//
//  AudioViewController.swift
//  FamilyArchives
//
//  Created by Zoe Henry on 4/14/19.
//  Copyright © 2019 Zoe Henry. All rights reserved.
//

import UIKit
import AVFoundation
import os.log

class AudioViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UITextViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    //MARK: Properties
    var nameTextField: UITextField!
    var personEventDescriptionTextView: UITextView!
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var playButton: UIButton!
    var audioPlayer: AVAudioPlayer!
    var newRecording = true
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var personEvent: PersonEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                        if let personEvent = self.personEvent {
                            self.navigationItem.title = personEvent.name
                            self.nameTextField.text = personEvent.name
//                            self.audioPlayer = try! AVAudioPlayer(contentsOf: personEvent.audioURL)
//                            let url = personEvent.audioURL!
//                            self.audioPlayer = try! AVAudioPlayer(contentsOf:
//                                URL(string: "www.youtube.com/watch?v=SjFo6l4c-oc")
                            self.newRecording = false
                            self.playButton.isEnabled = true
                            self.personEventDescriptionTextView.text = personEvent.personEventDescription
                            self.personEventDescriptionTextView.textColor = UIColor(red: 0.2745, green: 0.1255, blue: 0.4, alpha: 1.0)
                        }
                        self.updateSaveButtonState()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
    }
    
    
    func loadRecordingUI() {
        print("loading ui")
        let x_value = self.view.frame.width / 2 - 160
        
        view.backgroundColor = UIColor(red: 0.9882, green: 0.9569, blue: 0.851, alpha: 1.0)
        
        nameTextField = UITextField(frame: CGRect(x: x_value, y: 120, width: 320, height: 32))
        nameTextField.placeholder = "  Enter Name of Person or Event"
        nameTextField.textColor = UIColor(red: 0.302, green: 0.1882, blue: 0.4, alpha: 1.0)
        nameTextField.font = nameTextField.font?.withSize(14)
//        nameTextField.borderStyle = nameTextField.borderStyle.roundedRect
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.cornerRadius = 8.0
        nameTextField.backgroundColor = UIColor.white
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        recordButton = UIButton(frame: CGRect(x: x_value, y: 180, width: 320, height: 64))
        recordButton.backgroundColor = UIColor(red: 1, green: 0.7216, blue: 0.3725, alpha: 1.0)
        recordButton.layer.cornerRadius = 8
        recordButton.setTitle("Tap to Record", for: .normal)
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        
        playButton = UIButton(frame: CGRect(x: x_value, y: 260, width: 320, height: 64))
        playButton.backgroundColor = UIColor(red: 1, green: 0.4784, blue: 0.3529, alpha: 1.0)
        playButton.layer.cornerRadius = 8
        playButton.setTitle("Play Recording", for: .normal)
        playButton.addTarget(self, action: #selector(playAudioButtonTapped), for: .touchUpInside)
        playButton.isEnabled = false
        
        personEventDescriptionTextView = UITextView(frame: CGRect(x: x_value, y: 340, width: 320, height: 320))
        personEventDescriptionTextView.text = "Enter description"
        personEventDescriptionTextView.backgroundColor = UIColor(red: 0.9294, green: 0.898, blue: 0.8078, alpha: 1.0)
        personEventDescriptionTextView.textColor = UIColor(red: 0.302, green: 0.1882, blue: 0.4, alpha: 1.0)
        personEventDescriptionTextView.layer.cornerRadius = 8
        
        nameTextField.delegate = self
        personEventDescriptionTextView.delegate = self
        
        view.addSubview(nameTextField)
        view.addSubview(recordButton)
        view.addSubview(playButton)
        view.addSubview(personEventDescriptionTextView)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
        textField.textColor = UIColor(red: 0.2745, green: 0.1255, blue: 0.4, alpha: 1.0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UITextViewDelegate
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        // Hide the keyboard.
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(red: 0.302, green: 0.1882, blue: 0.4, alpha: 1.0) {
            textView.text = nil
            textView.textColor = UIColor(red: 0.2745, green: 0.1255, blue: 0.4, alpha: 1.0)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            personEventDescriptionTextView.text = "Enter description"
            personEventDescriptionTextView.textColor = UIColor(red: 0.302, green: 0.1882, blue: 0.4, alpha: 1.0)
        } else {
            personEventDescriptionTextView.text = textView.text
            personEventDescriptionTextView.textColor = UIColor(red: 0.2745, green: 0.1255, blue: 0.4, alpha: 1.0)
        }
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)

    }
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = UIImage(named: "audioRecordingPhoto")
        let audioURL = getFileURL()
        let personEventDescription = personEventDescriptionTextView.text ?? ""
        
        personEvent = PersonEvent(name: name, photo: photo, audioURL: audioURL, personEventDescription: personEventDescription)
    }
    
    //MARK: Actions
    func startRecording() {
        let audioFilename = getFileURL()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        if newRecording {
            let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            return path as URL
        } else {
            let path = personEvent!.audioURL
            return path as! URL
        }
        
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed
        }
        
        playButton.isEnabled = true
    }
    
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    @IBAction func playAudioButtonTapped(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Play Recording"){
            recordButton.isEnabled = false
            sender.setTitle("Stop", for: .normal)
            preparePlayer()
            audioPlayer.play()
        } else {
            audioPlayer.stop()
            sender.setTitle("Play Recording", for: .normal)
        }
    }
    
    func preparePlayer() {
        var error: NSError?
        do {
            print(getFileURL())
            if !newRecording {
                print("you have saved audio")
                audioPlayer = try AVAudioPlayer(contentsOf: getFileURL() as URL)
            } else {
                audioPlayer = try AVAudioPlayer(contentsOf: getFileURL() as URL)
            }
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 10.0
        }
    }
    
    //MARK: Delegates
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        playButton.setTitle("Play Recording", for: .normal)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}



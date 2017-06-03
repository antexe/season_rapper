//
//  TopViewController.swift
//  season_rapper
//
//  Created by 藤川慶 on 2017/06/03.
//  Copyright © 2017年 藤川慶. All rights reserved.
//

import UIKit
import Speech

class TopViewController: UIViewController {
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechRecognizer.delegate = self
        // 音声マイクの許可を取る
        requestSpeechAuthorization()
        // レコーディングをスタート
        try! startRecording()
        
        // BGM再生
        AudioPlayer.shared.playMusic(.op)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AudioPlayer.shared.stop()
    }
    
    @IBAction func Button1Tapped(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(1, forKey: "playerCount")
        ScreenTransitionManager.shared.goToTheme()
        
    }
    
    @IBAction func Button2Tapped(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(2, forKey: "playerCount")
        ScreenTransitionManager.shared.goToTheme()
    }
}



//声で画面遷移できるようにテスト
//BGM止めれば動く

extension TopViewController:SFSpeechRecognizerDelegate{
    
    fileprivate func requestSpeechAuthorization(){
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    break
                case .denied:
                    break
                case .restricted:
                    break
                case .notDetermined:
                    break
                }
            }
        }
    }
    
    
    fileprivate func startRecording() throws {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                
                print(result.bestTranscription.formattedString)
                //ある文字列をいうと画面遷移
                if result.bestTranscription.formattedString == "ほげ"{
                    print("aaa")
                }
                
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
    }
    
}

//extension TopViewController: SFSpeechRecognizerDelegate {
//    
//    fileprivate func requestSpeechAuthorization(){
//        SFSpeechRecognizer.requestAuthorization { authStatus in
//            /*
//             The callback may not be called on the main thread. Add an
//             operation to the main queue to update the record button's state.
//             */
//            OperationQueue.main.addOperation {
//                switch authStatus {
//                case .authorized:
//                    break
//                case .denied:
//                    break
//                case .restricted:
//                    break
//                case .notDetermined:
//                    break
//                }
//            }
//        }
//    }
//}

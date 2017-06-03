//
//  SpeechViewController.swift
//  season_rapper
//
//  Created by shoichiyamazaki on 2017/06/03.
//  Copyright © 2017年 藤川慶. All rights reserved.
//

import UIKit
import Speech

class SpeechViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var micImageView: UIImageView!
    
    var countdownTimer:Timer!
    var totalTime = 10
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var circleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        visualEffectView.alpha = 1
        
        // エフェクトビューのサイズを指定（オリジナル画像と同じサイズにする）
        visualEffectView.frame = self.view.frame
        self.view.insertSubview(visualEffectView, at: 0)
        
        // Do any additional setup after loading the view.
        
        // カウントダウンタイマー
        timerLabel.text = "\(timeFormatted(totalTime))"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        
        // レコーディングをスタート
        try! startRecording()
        // タイマーを再生
        startTimer()
    }
    
    private func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
            
            
            if totalTime < 10{
                timerLabel.textColor = UIColor.red
            }
            
        } else {
            endTimer()
        }
    }
    
    private func endTimer() {
        countdownTimer.invalidate()
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { 
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SpeechViewController: SFSpeechRecognizerDelegate {
    
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
                
                print("recognitionReq:\(recognitionRequest)")
                print("result:\(result)")
                print("hypothesis:\(result.transcriptions)")
                print("besttranscription:\(result.bestTranscription)")
                print("formatedStr:\(result.bestTranscription.formattedString)")
                
                let list = result.bestTranscription.segments.flatMap{$0}
                let list01 = result.transcriptions.flatMap{$0}
                
                for item in list {
                    print("01:\(item)")
                    item.substring
                    print("01-1:\(item.alternativeSubstrings)")
                }
                
                for item in list01{
                    print("02:\(item)")
                    print("02-1:\(item.formattedString)")
                }
                
                self.inputTextView.text = result.bestTranscription.formattedString
                
                //しゃべると輪が広がる
                UIView.animate(withDuration: 5, delay: 0, options: [.curveLinear], animations: { 
                    self.circleView.transform = CGAffineTransform.init(scaleX: 10, y: 10)
                    self.circleView.alpha = 1
                }, completion: { (Bool) in
                    self.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.circleView.alpha = 0
                })
                
                
                
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

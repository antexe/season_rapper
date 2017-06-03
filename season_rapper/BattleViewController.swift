//
//  BattleViewController.swift
//  season_rapper
//
//  Created by 藤川慶 on 2017/06/03.
//  Copyright © 2017年 藤川慶. All rights reserved.
//

import UIKit
import Speech

class BattleViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var aiIcon: UIImageView!
    @IBOutlet weak var userIcon: UIImageView!
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    var countdownTimer:Timer!
    var totalTime = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //BGM再生
        AudioPlayer.shared.playMusic(.battle)
        
        // カウントダウンタイマー
        timerLabel.text = "\(timeFormatted(totalTime))"
        // 音声マイクの許可を取る
        requestSpeechAuthorization()
        
        // アイコンタップイベント(仮)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(BattleViewController.aiTap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(BattleViewController.userTap(_:)))
        aiIcon.addGestureRecognizer(tap1)
        userIcon.addGestureRecognizer(tap2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        
        // タイマーを再生
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AudioPlayer.shared.stop()
    }
    
    // MARK: - カウントダウンタイマー ------------------------------------------------------------
    
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
    }
    
    // MARK: - カウントダウンタイマー ここまで---------------------------------------------------
}

// スピーチ系
// MARK: - SFSpeechRecognizerDelegate
extension BattleViewController: SFSpeechRecognizerDelegate {
    
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
}

extension BattleViewController {
    
    func aiTap(_ sender: UITapGestureRecognizer){
        ScreenTransitionManager.shared.goToCPVoice()
    }
    
    func userTap(_ sender: UITapGestureRecognizer){
        ScreenTransitionManager.shared.goToSpeech()
    }
    
}

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

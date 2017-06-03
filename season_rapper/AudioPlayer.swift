//
//  AudioPlayer.swift
//  season_rapper
//
//  Created by 藤川慶 on 2017/06/04.
//  Copyright © 2017年 藤川慶. All rights reserved.
//

import Foundation
import AVFoundation
import SwaggerClient

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    static let shared = AudioPlayer()
    private override init(){
    }
    var audioPlayer:AVAudioPlayer?
    
    enum MusicName: String {
        case op
        case battle
    }
    
    func playMusic(_ name: MusicName){
        
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: name.rawValue, ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl, fileTypeHint: AVFileTypeMPEGLayer3)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        audioPlayer?.prepareToPlay()
        audioPlayer?.delegate = self
        audioPlayer?.play()
    }
  
  
    func playTalk(_ message: String){
        TtsgetAPI.ttsGet(username: "spajam2017", password: "RpM5m8BP", text: message, speakerName: "nozomi", ext: "wav", completion: {(response, err) in
      
        var audioError:NSError?
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            self.audioPlayer = try AVAudioPlayer(data: response!)
        } catch let error as NSError {
            audioError = error
            self.audioPlayer = nil
        }
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.delegate = self
        self.audioPlayer?.play()
      })
    }
  
    func stop(){
        audioPlayer?.stop()
    }

}

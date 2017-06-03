//
//  CPVoiceViewController.swift
//  season_rapper
//
//  Created by 藤川慶 on 2017/06/04.
//  Copyright © 2017年 藤川慶. All rights reserved.
//

import UIKit

class CPVoiceViewController: UIViewController {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var countdownTimer:Timer!
    var totalTime = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // タイマーを再生
        startTimer()
    }
    
// ------- タイマーここから -----------------------------------------------
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
// -------タイマーここまで -----------------------------------------------
    
}

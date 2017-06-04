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
    @IBOutlet weak var dotringImageView: UIImageView!
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    var countdownTimer:Timer!
    var totalTime = 60
    
    var i:Int = 0
    
    var imgView01:UIImageView!
    var imgView02:UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img01 = UIImage(named: "user")
        let img02 = UIImage(named: "AI")
        
        
        let imgViewWidth:CGFloat = 100
        imgView01 = UIImageView(frame: CGRect(x: (self.view.frame.width - imgViewWidth)/2, y: self.view.frame.height/2 + dotringImageView.frame.height/2 - imgViewWidth/2, width: imgViewWidth, height: imgViewWidth))
        imgView01.backgroundColor = UIColor.white
        imgView02 = UIImageView(frame: CGRect(x: (self.view.frame.width - imgViewWidth)/2, y: self.view.frame.height/2 - dotringImageView.frame.height/2 - imgViewWidth/2, width: imgViewWidth, height: imgViewWidth))
        imgView02.backgroundColor = UIColor.white
        imgView01.layer.masksToBounds = true
        imgView02.layer.masksToBounds = true
        imgView01.layer.cornerRadius = imgView01.frame.width/2
        imgView02.layer.cornerRadius = imgView02.frame.width/2
        imgView01.image = img01
        imgView02.image = img02
        
        imgView02.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        
        
        self.view.addSubview(imgView01)
        self.view.addSubview(imgView02)
        //BGM再生
        AudioPlayer.shared.playMusic(.battle)
        
        // カウントダウンタイマー
        timerLabel.text = "\(timeFormatted(totalTime))"
        // 音声マイクの許可を取る
        requestSpeechAuthorization()
        
        // アイコンタップイベント(仮)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(BattleViewController.aiTap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(BattleViewController.userTap(_:)))
//        aiIcon.addGestureRecognizer(tap1)
//        userIcon.addGestureRecognizer(tap2)
        
        imgView01.addGestureRecognizer(tap2)
        imgView02.addGestureRecognizer(tap1)
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
            
//            if totalTime%10 == 0{
//                self.transition()
//                self.transition02()
//                i += 1
//            }
            
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

extension BattleViewController{
    
    
    fileprivate func transition(){
        let startAngle:CGFloat = CGFloat.pi*CGFloat(i) + CGFloat.pi/2
        let endAngle:CGFloat = CGFloat.pi*CGFloat((i - 1)) + CGFloat.pi/2
        let circleOriginalPoint = CGPoint(x: dotringImageView.center.x, y: dotringImageView.center.y)
        let circleRadius:CGFloat = dotringImageView.frame.width/2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x:circleOriginalPoint.x,y:circleOriginalPoint.y), radius: circleRadius, startAngle: startAngle, endAngle:endAngle, clockwise: true)
        var circlePosition01:CGPoint = CGPoint(x: imgView01.center.x, y: imgView01.center.y)
        
        
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.imgView01.layer.position = circlePosition01
        }
        let animation01 = CAKeyframeAnimation(keyPath: "position");
        animation01.duration = 1
        animation01.repeatCount = 1
        animation01.path = circlePath.cgPath
        circlePosition01 = animation01.path!.currentPoint
        CATransaction.commit()
        
        
        
        self.imgView01.layer.add(animation01, forKey: nil)
        UIView.animate(withDuration: 1) {
            switch self.i%2 == 0{
            case true:
                self.imgView01.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            case false:
                self.imgView01.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            }
            
        }
        
    }
    
    fileprivate func transition02(){
        let startAngle:CGFloat = CGFloat.pi*CGFloat(i) - CGFloat.pi/2
        let endAngle:CGFloat = CGFloat.pi*CGFloat((i - 1)) - CGFloat.pi/2
        let circleOriginalPoint = CGPoint(x: dotringImageView.center.x, y: dotringImageView.center.y)
        let circleRadius:CGFloat = dotringImageView.frame.width/2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x:circleOriginalPoint.x,y:circleOriginalPoint.y), radius: circleRadius, startAngle: startAngle, endAngle:endAngle, clockwise: true)
        var circlePosition02:CGPoint = CGPoint(x: imgView02.center.x, y: imgView02.center.y)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.imgView02.layer.position = circlePosition02
        }
        let animation02 = CAKeyframeAnimation(keyPath: "position");
        animation02.duration = 1
        animation02.repeatCount = 1
        animation02.path = circlePath.cgPath
        circlePosition02 = animation02.path!.currentPoint
        CATransaction.commit()
        self.imgView02.layer.add(animation02, forKey: nil)
        
        
        UIView.animate(withDuration: 1) {
        switch self.i%2 == 0{
            case true:
            self.imgView02.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            case false:
            self.imgView02.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        }
        }
    }
    
}

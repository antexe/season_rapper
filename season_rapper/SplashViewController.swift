//
//  SplashViewController.swift
//  season_rapper
//
//  Created by 藤川慶 on 2017/06/04.
//  Copyright © 2017年 藤川慶. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class SplashViewController: UIViewController {

    @IBOutlet weak var movieView: AVPlayerView!
    
    var videoPlayer : AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // パスからassetを生成.
        let path = Bundle.main.path(forResource: "op", ofType: "mp4")
        let fileURL = URL(fileURLWithPath: path!)
        let avAsset = AVURLAsset(url: fileURL, options: nil)
        
        // AVPlayerに再生させるアイテムを生成.
        let playerItem = AVPlayerItem(asset: avAsset)
        // AVPlayerを生成.
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        // 動画再生完了の監視
        NotificationCenter.default.addObserver(self, selector: #selector(SplashViewController.movieEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        movieView.setPlayer(videoPlayer)
        self.videoPlayer.play()
    }
    
    func movieEnd(_ sender: Any) {
        ScreenTransitionManager.shared.goToTop()
    }
    
}

// レイヤーをAVPlayerLayerにする為のラッパークラス.
final class AVPlayerView: UIView {
    
    enum VideoGravity {
        case resizeAspect
        case resizeAspectFill
        case resize
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override class var layerClass : AnyClass{
        return AVPlayerLayer.self
    }
    
    func setVideoGravity(_ gravity: VideoGravity) {
        let layer = self.layer as! AVPlayerLayer
        switch(gravity) {
        case .resizeAspect:
            layer.videoGravity = AVLayerVideoGravityResizeAspect
        case .resizeAspectFill:
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        case .resize:
            layer.videoGravity = AVLayerVideoGravityResize
        }
    }
    
    func setPlayer(_ player: AVPlayer) {
        let layer = self.layer as! AVPlayerLayer
        layer.player = player
    }
}


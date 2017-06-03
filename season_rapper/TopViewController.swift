//
//  TopViewController.swift
//  season_rapper
//
//  Created by 藤川慶 on 2017/06/03.
//  Copyright © 2017年 藤川慶. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // BGM再生
        AudioPlayer.shared.playMusic(.op)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AudioPlayer.shared.stop()
    }
    
    @IBAction func Button1Tapped(_ sender: Any) {
        ScreenTransitionManager.shared.goToTheme()
    }
    
    @IBAction func Button2Tapped(_ sender: Any) {
        ScreenTransitionManager.shared.goToTheme()
    }
}


//
//  ThemeViewController.swift
//  season_rapper
//
//  Created by 藤川慶 on 2017/06/03.
//  Copyright © 2017年 藤川慶. All rights reserved.
//

import UIKit


class ThemeViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 3秒後にバトル画面へ遷移
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            ScreenTransitionManager.shared.goToBattle()
        }
    }

}





//
//  LastViewController.swift
//  season_rapper
//
//  Created by 藤川慶 on 2017/06/04.
//  Copyright © 2017年 藤川慶. All rights reserved.
//

import UIKit

class LastViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playBackButtonTapped(_ sender: Any) {
        // 録音したラップの音楽を再生する
    }
   
    @IBAction func goToTopButtonTapped(_ sender: Any) {
        ScreenTransitionManager.shared.goToTop()
    }

}

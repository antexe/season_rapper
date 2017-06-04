//
//  ResultViewController.swift
//  season_rapper
//
//  Created by 藤川慶 on 2017/06/04.
//  Copyright © 2017年 藤川慶. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    
    @IBOutlet weak var winnerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            ScreenTransitionManager.shared.goToLast()
        }
    }
}

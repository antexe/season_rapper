//
//  ScreenTransitionManager.swift
//  season_rapper
//
//  Created by 藤川慶 on 2017/06/03.
//  Copyright © 2017年 藤川慶. All rights reserved.
//

import UIKit

class ScreenTransitionManager {
    
    static let shared = ScreenTransitionManager()
    private init(){
        
    }
    
    private var targetViewController: UIViewController? {
        // 現在一番上にあるViewControllerを取得する
        var tc = UIApplication.shared.keyWindow?.rootViewController
        while tc?.presentedViewController != nil {
            tc = tc!.presentedViewController
        }
        return tc
    }
    
    /// 横にスライド表示
    private func show(_ controller: UIViewController){
        targetViewController?.show(controller, sender: targetViewController)
    }
    
    /// 新しいnavigationControllerでモーダル表示
    /// modalPresentationStyleやmodalTransitionStyleを設定しなければ下から出てくる
    private func presentModalWithNavigation(_ controller: UIViewController){
        let nc = UINavigationController(rootViewController: controller)
        targetViewController?.present(nc, animated: true, completion: nil)
    }
    
    /// クロスディゾルブでスーッとモーダル表示
    private func showTranslucenceView(_ controller: UIViewController) {
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        targetViewController?.present(controller, animated: true, completion: nil)
    }
    
    // トップに飛ぶ
    func goToTop(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else { return }
        show(controller)
    }
    
    //　テーマ画面に飛ぶ
    func goToTheme(){
        let storyboard = UIStoryboard(name: "Theme", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else { return }
        show(controller)
    }

    //　バトル画面に飛ぶ
    func goToBattle(){
        let storyboard = UIStoryboard(name: "Battle", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else { return }
        show(controller)
    }
    
    // スピーチ画面に飛ぶ
    func goToSpeech(){
        let storyboard = UIStoryboard(name: "Speech", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else { return }
        showTranslucenceView(controller)
    }
    
    // 結果のViewControllerに飛ぶ
    func goToResult(){
        let storyboard = UIStoryboard(name: "Result", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else { return }
        show(controller)
    }
    
    // 最後のviewControllerに飛ぶ
    func goToLast(){
        let storyboard = UIStoryboard(name: "Last", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else { return }
        show(controller)
    }
}

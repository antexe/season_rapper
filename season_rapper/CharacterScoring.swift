//
//  CharacterScoring.swift
//  season_rapper
//
//  Created by 山田卓 on 2017/06/04.
//  Copyright © 2017 藤川慶. All rights reserved.
//

import Foundation

class CharacterScoring {
    
    /*
     Usage:
     
     let rapString = "さくらさく、オレのリリックさきほこる"
     let score = CharacterScoring.shared.scoring(rapString)
     print("スコアは\(score)点") // スコアは69点
     
     */
    
    static let shared = CharacterScoring()
    private init(){
    }
    
    func scoring(_ rapString: String) -> Int {
        
        /// 検索するキーワード
        let searchKeyword1: String = "さくら"
        let searchKeyword2: String = "桜"
        let searchKeyword3: String = "サクラ"
        
        /// スコア
        var score = 0
        
        /// "さくら"で検索
        var keyCount = 0
        var nextRange = rapString.startIndex..<rapString.endIndex //最初は文字列全体から探す
        while let range = rapString.range(of: searchKeyword1, options: .caseInsensitive, range: nextRange) { //.caseInsensitiveで探す方が、lowercaseStringを作ってから探すより普通は早い
            keyCount += 1
            nextRange = range.upperBound..<rapString.endIndex //見つけた単語の次(range.upperBound)から元の文字列の最後までの範囲で次を探す
        }
        
        /// "桜"で検索
        while let range = rapString.range(of: searchKeyword2, options: .caseInsensitive, range: nextRange) { //.caseInsensitiveで探す方が、lowercaseStringを作ってから探すより普通は早い
            keyCount += 1
            nextRange = range.upperBound..<rapString.endIndex //見つけた単語の次(range.upperBound)から元の文字列の最後までの範囲で次を探す
        }
        
        /// "サクラ"で検索
        while let range = rapString.range(of: searchKeyword3, options: .caseInsensitive, range: nextRange) { //.caseInsensitiveで探す方が、lowercaseStringを作ってから探すより普通は早い
            keyCount += 1
            nextRange = range.upperBound..<rapString.endIndex //見つけた単語の次(range.upperBound)から元の文字列の最後までの範囲で次を探す
        }
        
        /// 採点ロジック ①指定キーワード1つに付き15ポイント加点 ②文字数1文字につき3ポイント加点
        let keyCountPoint = keyCount * 15
        let charactersCountPoint = rapString.characters.count * 3
        
        /// 採点
        score = keyCountPoint + charactersCountPoint
        
        return score
        
    }
    
    
}

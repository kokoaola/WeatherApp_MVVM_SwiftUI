//
//  String+Extensions.swift
//  WeatherApp
//
//  Created by koala panda on 2023/12/12.
//

import Foundation


extension String {
    
    /// URLで使用できる形式に文字列をエスケープするメソッド
    func escaped() -> String {
        // .urlHostAllowedを使用して、URLに適した形式に文字列をエスケープ
        // エスケープに失敗した場合は元の文字列を返す
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}

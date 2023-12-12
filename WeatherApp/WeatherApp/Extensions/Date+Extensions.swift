//
//  Date+Extensions.swift
//  WeatherApp
//
//  Created by koala panda on 2023/12/12.
//

import Foundation


extension Date {
    
    /// 日付を特定のフォーマットの文字列に変換するメソッド
    func formatAsString() -> String {
        let formatter = DateFormatter()
        // 時間フォーマットを設定（例: "hh:mm a"）
        formatter.dateFormat = "hh:mm a"
        // 日付を指定したフォーマットの文字列に変換
        return formatter.string(from: self)
    }
}

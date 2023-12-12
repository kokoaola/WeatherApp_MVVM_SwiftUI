//
//  UserDefaults+Extensions.swift
//  WeatherApp
//
//  Created by koala panda on 2023/12/12.
//

import Foundation


// UserDefaultsの拡張
extension UserDefaults {
    
    /// UserDefaultsから温度単位を取得するプロパティ
    var unit: TemperatureUnit {
        // UserDefaultsから"unit"キーで保存された値を取得
        guard let value = self.value(forKey: "unit") as? String else {
            // 取得に失敗した場合はデフォルト値（.kelvin）を返す
            return .kelvin
        }
        // 取得した値をTemperatureUnit型に変換
        // 変換に失敗した場合はデフォルト値（.kelvin）を返す
        return TemperatureUnit(rawValue: value) ?? .kelvin
    }
}

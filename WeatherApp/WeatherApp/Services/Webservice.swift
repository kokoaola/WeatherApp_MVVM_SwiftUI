//
//  Webservice.swift
//  WeatherAppSwiftUI
//
//  Created by Mohammad Azam on 3/5/21.
//

import Foundation



/// ネットワークリクエストで発生するエラーを表すNetworkError型
enum NetworkError: Error {
    case badURL // URLが不正な場合のエラー
    case noData // データが取得できない場合のエラー
}



/// APIを通じてデータを取得するためのメソッドを提供するWebserviceクラス
class Webservice {
    
    /// getWeatherByCityメソッドは、指定された都市に基づいて天気情報を取得する
    /// - Parameters:
    ///   - city: 天気情報を取得する都市の名前
    ///   - completion: 天気情報取得処理が完了した後に呼び出されるコールバック関数
    func getWeatherByCity(city: String, completion: @escaping ((Result<Weather, NetworkError>) -> Void)) {
        
        // 指定された都市名を使用して天気情報のURLを生成
        // URLが不正な場合は、早期リターンで.badURLエラーを返す
        guard let weatherURL = Constants.Urls.weatherByCity(city: city) else {
            return completion(.failure(.badURL))
        }
        
        // URLSessionを使ってデータタスクを作成し、非同期で天気情報を取得
        URLSession.shared.dataTask(with: weatherURL) { (data, _, error) in
            
            // データが存在しない、またはエラーがある場合は、.noDataエラーを返す
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            // 取得したデータをJSON形式からWeatherResponse型にデコード
            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
            if let weatherResponse = weatherResponse {
                completion(.success(weatherResponse.weather))
            }
            
        }.resume() // データタスクを開始
    }
}

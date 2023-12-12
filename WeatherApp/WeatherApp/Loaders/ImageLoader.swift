//
//  ImageLoader.swift
//  WeatherApp
//
//  Created by koala panda on 2023/12/12.
//

import Foundation


/// ImageLoaderはURLから画像データを非同期でダウンロードするクラス
class ImageLoader: ObservableObject {
    
    // ダウンロードした画像データを保持するためのPublishedプロパティ
    @Published var downloadedData: Data?
    
    /// 指定されたURLから画像をダウンロードするメソッド
    func downloadImage(url: String) {
        // 受け取った文字列からURLオブジェクトを生成
        guard let imageURL = URL(string: url) else {
            return
        }
        
        // URLSessionを使用して非同期でデータタスクを作成し、実行
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            // データが存在し、エラーがないことを確認
            guard let data = data, error == nil else {
                return
            }
            
            // メインスレッドでダウンロードしたデータを設定
            // UIの更新はメインスレッドで行う必要があるため
            DispatchQueue.main.async {
                self.downloadedData = data
            }
        }.resume() // データタスクを開始
    }
}


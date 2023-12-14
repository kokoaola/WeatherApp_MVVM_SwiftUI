//
//  URLImage.swift
//  URLImageDemo
//
//  Created by Mohammad Azam on 6/17/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//

import SwiftUI


/// URLImageはURLから画像を取得して表示するためのView
struct URLImage: View {
    
    // 表示する画像のURL
    let url: String
    // 画像がまだダウンロードされていないときに表示するプレースホルダー画像の名前
    let placeholder: String
    
    // ImageLoaderのインスタンスを監視対象オブジェクトとして使用
    @ObservedObject var imageLoader = ImageLoader()
    
    // 初期化処理。URLとプレースホルダー画像を設定
    init(url: String, placeholder: String = "placeholder") {
        self.url = url
        self.placeholder = placeholder
        // ImageLoaderを使用して指定されたURLから画像をダウンロード
        self.imageLoader.downloadImage(url: self.url)
    }
    
    // Viewの本体。ダウンロードされた画像またはプレースホルダー画像を表示
    var body: some View {
        
        // ImageLoaderからダウンロードされたデータがある場合
        if let data = self.imageLoader.downloadedData {
            // ダウンロードされたデータからUIImageを作成し、resizableで返す
            
           Image(uiImage: UIImage(data: data)!).resizable()
        } else {
            // ダウンロードされたデータがない場合はプレースホルダー画像を表示
            Image(systemName: "photo").foregroundColor(.gray)
        }
        
    }
}


struct URLImage_Previews: PreviewProvider {
    static var previews: some View {
        URLImage(url: "https://fyrafix.files.wordpress.com/2011/08/url-8.jpg")
    }
}

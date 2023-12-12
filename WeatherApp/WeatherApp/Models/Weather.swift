//
//  Weather.swift
//  WeatherApp
//
//  Created by koala panda on 2023/12/12.
//

import Foundation


/// WeatherResponse構造体: 必要なものを集めたモデル階層の一番上のデータ
struct WeatherResponse: Decodable {
    // 都市名を保持するプロパティ
    let name: String
    // 天気の詳細情報を保持するWeather型のプロパティ、実際のJSONのキーは"main"
    var weather: Weather
    // 天気アイコン情報の配列を保持するプロパティ、実際のJSONのキーは"weather"
    let icon: [WeatherIcon]
    // 日の出・日の入り時間情報を保持するSys型のプロパティ
    let sys: Sys
    
    
    /// JSONのキーとプロパティのマッピングを定義する列挙型
    // WeatherResponseのプロパティ名と実際のJSONのプロパティ名が違っているのでここで合わせる
    private enum CodingKeys: String, CodingKey {
        // 'name'キーに対応するプロパティ
        case name
        // JSONの"main"キーをweatherプロパティにマッピング
        case weather = "main"
        // JSONの"weather"キーをiconプロパティにマッピング
        case icon = "weather"
        // 'sys'キーに対応するプロパティ
        case sys = "sys"
    }
    
    /// WeatherKeys列挙型: weatherプロパティ("main"キー)に関連するJSONキーを定義
    enum WeatherKeys: String, CodingKey {
        // JSONの"temp"キーをtemperatureプロパティにマッピング
        case temperature = "temp"
    }
    
    /// デコーダからのデータを読み込んでプロパティにセットする
    init(from decoder: Decoder) throws {
        // CodingKeysに定義されたキーごとにデータをデコードするためのコンテナを取得
        // 最も外側の{}に囲まれている親コンテナになる
        //CodingKeys=WeatherResponse構造体で定義されたキーとプロパティを使用してデータを取得する
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // weather(JSONでは"main")キーでネストされたコンテナを取得
        // ネストされた別のオブジェクトを含んでおり、そのオブジェクト内でさらに temperature などのプロパティが存在する。そのため、ネストされたコンテナ weatherContainer を使用して、内部のプロパティを個別にデコードする必要があり、再度コンテナを使用する
        //WeatherKeysは、ネストされた"main"オブジェクト内のキーとWeather構造体のプロパティをマッピングするための列挙型
        let weatherContainer = try container.nestedContainer(keyedBy: WeatherKeys.self, forKey: .weather)
        
        // weatherContainer（"main"キーによってネストされたJSONオブジェクトに対応するコンテナ）から、temperatureキーに対応するデータをデコード
        // Weather型の'temperature'キーに対応するデータをDouble型としてデコードして格納
        let temperature = try weatherContainer.decode(Double.self, forKey: .temperature)
        
        
        // 各キーに対応するデータをデコードしてプロパティにセット
        // 'name'キーに対応するデータをデコード
        name = try container.decode(String.self, forKey: .name)
        // 'icon'キーに対応するデータをデコード
        icon = try container.decode([WeatherIcon].self, forKey: .icon)
        // 'sys'キーに対応するデータをデコード
        sys = try container.decode(Sys.self, forKey: .sys)
        
        // Weather型のプロパティにデコードされたデータをセット
        weather = Weather(city: name, temperature: temperature, icon: icon.first!.icon, sunrise: sys.sunrise, sunset: sys.sunset)
    }
}


/// Weather構造体(元のJSONのキーはmainプロパティ)
/// 特定の地点の天気情報を格納する構造体。都市名、温度、アイコン、日の出・日の入りの時間が含まれる
struct Weather: Decodable {
    // 都市名を保持するプロパティ
    let city: String
    // 温度を保持するプロパティ
    let temperature: Double
    // アイコンIDを保持するプロパティ
    let icon: String
    // 日の出の時間を保持するプロパティ
    let sunrise: Date
    // 日の入りの時間を保持するプロパティ
    let sunset: Date
}


/// Sys構造体(元のJSONのキーはsysプロパティ)
/// 日の出と日の入りの時間情報をデコードするために使用される。
struct Sys: Decodable {
    // 日の出の時間を保持するプロパティ
    let sunrise: Date
    // 日の入りの時間を保持するプロパティ
    let sunset: Date
    
    // JSONのキーとプロパティのマッピングを定義する列挙型
    private enum CodingKeys: String, CodingKey {
        // 'sunrise'キーに対応するプロパティ
        case sunrise = "sunrise"
        // 'sunset'キーに対応するプロパティ
        case sunset = "sunset"
    }
    
    /// イニシャライザ: JSONデコーダから日の出と日の入りの時間情報を読み込む。
    init(from decoder: Decoder) throws {
        // キーごとにデータをデコードするためのコンテナを取得
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // 'sunrise'キーに対応するデータをUNIX時間でデコードし、Date型に変換
        let sunriseTimeInterval = try container.decode(Int32.self, forKey: .sunrise)
        // 'sunset'キーに対応するデータをUNIX時間でデコードし、Date型に変換
        let sunsetTimeInterval = try container.decode(Int32.self, forKey: .sunset)
        sunrise = Date(timeIntervalSince1970: TimeInterval(sunriseTimeInterval))
        sunset = Date(timeIntervalSince1970: TimeInterval(sunsetTimeInterval))
    }
}



/// WeatherIcon構造体: 天気アイコンに関する情報を格納する構造体
struct WeatherIcon: Decodable {
    // 天気のメインカテゴリを表す文字列型のプロパティ
    let main: String
    // 天気の説明を表す文字列型のプロパティ
    let description: String
    // アイコンIDを表す文字列型のプロパティ
    let icon: String
}







/*
 {
 
 "coord":{
 "lon":139.6917,
 "lat":35.6895
 },
 
 //Appではiconって名前のプロパティ
 //オブジェクトの配列の各要素はWeatherIcon型を割り当てている
 //ネストしているように見えるけど実際は配列を直接含んでいるだけのため、decode([中の型].self, forKey: "main")を用いて直接配列全体をデコードが可能
 
 "weather":[
 {
 "id":500,
 "main":"Rain",
 "description":"light rain",
 "icon":"10n"
 }
 ],
 
 "base":"stations",
 
 //weatherって名前のプロパティ
 //オブジェクトがネストしている
 //親とは別のコンテナnestedContainer(keyedBy:forKey:) を使用してそのオブジェクト内部のデータにアクセスし、内部のプロパティを個別にデコードする必要がある
 "main":{
 "temp":287.92,
 "feels_like":287.46,
 "temp_min":287.45,
 "temp_max":288.73,
 "pressure":1009,
 "humidity":77
 },
 
 "visibility":10000,
 
 "wind":{
 "speed":5.14,
 "deg":30
 },
 
 "rain":{
 "1h":0.65
 },
 
 "clouds":{
 "all":75
 },
 
 "dt":1702377004,
 
 //sysって名前のプロパティ（そのまま）
 "sys":{
 "type":2,
 "id":268395,
 "country":"JP",
 "sunrise":1702330868,
 "sunset":1702366096
 },
 
 "timezone":32400,
 
 
 "id":1850144,
 
 //nameって名前のプロパティ（そのまま）
 "name":"Tokyo",
 
 "cod":200
 }
 
 */

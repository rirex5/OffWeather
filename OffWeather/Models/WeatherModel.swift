//
//  WeatherModel.swift
//  OffWeather
//
//  Created by Mercury on 2019/12/16.
//  Copyright © 2019 Rirex. All rights reserved.
//

import RealmSwift

class WeatherModel {
    func save(weatherRLM: WeatherRLM) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(weatherRLM)
            }
        } catch {}
    }
    
    func readAll() -> [WeatherRLM] {
        var weatherRLMs: [WeatherRLM] = []
        do {
            let realm = try Realm()
            weatherRLMs = realm.objects(WeatherRLM.self).map( { $0 } )
        } catch {}
        weatherRLMs.sort { $0.createdDate < $1.createdDate }
        return weatherRLMs
    }
    
    func readFor24h() -> [WeatherRLM] {
        let yesterday = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))!
        var weatherRLMs: [WeatherRLM] = []
        do {
            let realm = try Realm()
            weatherRLMs = realm.objects(WeatherRLM.self).filter("createdDate <= %@", yesterday).map( { $0 } )
        } catch {}
        weatherRLMs.sort { $0.createdDate < $1.createdDate }
        return weatherRLMs
    }
}

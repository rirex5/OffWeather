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
    
    func readFor(hour: Int) -> [WeatherRLM] {
        // 時間前
        let comps = DateComponents(hour: -1 * hour, minute: 0)
        let previousDate = Calendar.current.date(byAdding: comps, to: Date())!
        var weatherRLMs: [WeatherRLM] = []
        do {
            let realm = try Realm()
            weatherRLMs = realm.objects(WeatherRLM.self).filter("createdDate >= %@", previousDate).map( { $0 } )
            
            print("previousDate: \(previousDate)")
        } catch {}
        weatherRLMs.sort { $0.createdDate < $1.createdDate }
        return weatherRLMs
    }
}

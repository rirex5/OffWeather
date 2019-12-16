//
//  WeatherRLM.swift
//  OffWeather
//
//  Created by Mercury on 2019/12/16.
//  Copyright © 2019 Rirex. All rights reserved.
//

import RealmSwift

class WeatherRLM: Object {
    
    @objc dynamic var weatherId: String = ""
    @objc dynamic var pressure: Double = 0.0
    @objc dynamic var altitude: Double = 0.0
    @objc dynamic var createdDate: Date = Date()
    var seaLevelPressure: Double {
        get {
            let temperature = 15.0
            let num1 = 1.0-(0.0065*altitude)/(temperature+0.0065*altitude+273.15)
            let num2 = pow(num1, -5.257)
            let seaLevelPressure = pressure * num2
            return seaLevelPressure
        }
    }
    
    override static func primaryKey() -> String? {
        return "weatherId"
    }
    
    convenience init(pressure: Double, altitude: Double, createdDate: Date) {
        self.init()
        self.weatherId = UUID().uuidString
        self.pressure = pressure
        self.altitude = altitude
        self.createdDate = createdDate
    }

}


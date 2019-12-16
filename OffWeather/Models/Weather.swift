//
//  Weather.swift
//  OffWeather
//
//  Created by Mercury on 2019/12/16.
//  Copyright © 2019 Rirex. All rights reserved.
//

import Foundation

struct Weather {
    
    var weatherId: String
    var pressure: Double
    var altitude: Double
    var createdDate: Date
    var seaLevelPressure: Double {
        get {
            let temperature = 15.0
            let num1 = 1.0-(0.0065*altitude)/(temperature+0.0065*altitude+273.15)
            let num2 = pow(num1, -5.257)
            let seaLevelPressure = pressure * num2
            return seaLevelPressure
        }
    }
    
    init(pressure: Double, altitude: Double, createdDate: Date) {
         self.weatherId = UUID().uuidString
         self.pressure = pressure
         self.altitude = altitude
         self.createdDate = createdDate
     }
}

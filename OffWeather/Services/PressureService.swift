//
//  PressureService.swift
//  OffWeather
//
//  Created by Mercury on 2019/12/16.
//  Copyright © 2019 Rirex. All rights reserved.
//

import CoreMotion
import CoreLocation

class PressureService: NSObject, CLLocationManagerDelegate {
    
    static let shared: PressureService = PressureService()
    
    private override init() {
        super.init()
    }
    
    
    let altimeter = CMAltimeter()
    let locationManager = CLLocationManager()
    var pressure: Double?
    var altitude: Double?
    
    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func requestAirpessure() {
        // 高度
        if (CMAltimeter.isRelativeAltitudeAvailable()) {
            altimeter.startRelativeAltitudeUpdates(to: .main, withHandler:
                {
                    data, error in
                    if error == nil {
                        // self.altimeter.stopRelativeAltitudeUpdates()
                        // print(Double(truncating: data!.pressure) * 10)
                        self.pressure = Double(truncating: data!.pressure) * 10
                    }
            })
        }
        
        // 位置情報
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    // 位置情報取得時
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        altitude = locations.first!.altitude
    }
    
    func getPressure() -> Double? {
        return pressure
    }
    
    func getSeaLevelPressure() -> Double? {
        guard let pressure = pressure else {            
            return nil
        }
        guard let altitude = altitude else {
            return nil
        }
        let templature = 15.0
        let num1 = 1.0-(0.0065*altitude)/(templature+0.0065*altitude+273.15)
        let num2 = pow(num1, -5.257)
        let seaLevelPressure = pressure * num2
        return seaLevelPressure
    }
    
}

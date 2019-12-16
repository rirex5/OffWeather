//
//  PressureService.swift
//  OffWeather
//
//  Created by Mercury on 2019/12/16.
//  Copyright © 2019 Rirex. All rights reserved.
//

import CoreMotion   // 気圧取得(CMAltimeter)に必要
import CoreLocation // 高度取得(CLLocationManager)に必要

class PressureService: NSObject, CLLocationManagerDelegate {
    
    static let shared: PressureService = PressureService() // シングルトン
    private override init() {
        super.init()
    }
    
    let altimeter = CMAltimeter()
    let locationManager = CLLocationManager()
    public private(set) var altitude: Double?
    public private(set) var pressure: Double?
    var seaLevelPressure: Double? { // (1)式を使って海面気圧に補正
        get {
            guard let altitude = altitude else { return nil }
            guard let pressure = pressure else { return nil }
            let temperature = 15.0
            let num1 = 1.0 - ( 0.0065 * altitude) / (temperature + 0.0065 * altitude + 273.15)
            let num2 = pow(num1, -5.257)
            let seaLevelPressure = pressure * num2
            return seaLevelPressure
        }
    }
    
    // 位置情報取得権限のリクエスト
    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    // 気圧取得開始のリクエスト
    func requestPressure() {
        if (CMAltimeter.isRelativeAltitudeAvailable()) {
            altimeter.startRelativeAltitudeUpdates(to: .main, withHandler:
                {
                    data, error in
                    if error == nil {
                        self.pressure = Double(truncating: data!.pressure) * 10
                    }
            })
        }
    }
    
    // 高度情報(位置情報)取得開始のリクエスト
    func requestLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    // 位置情報が更新されるたびに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        altitude = locations.first!.altitude
    }
    
}

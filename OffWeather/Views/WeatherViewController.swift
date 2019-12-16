//
//  WeatherViewController.swift
//  OffWeather
//
//  Created by Mercury on 2019/12/16.
//  Copyright © 2019 Rirex. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, SchedulerServiceDelegate {
    
    let pressureService = PressureService.shared
    let scheduler = SchedulerService()
    let weatherModel = WeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pressureService.requestAuthorization()
        pressureService.requestAirpessure()
        scheduler.delegate = self
        scheduler.setScheduler(updateInterval: 10)
    }

    func update() {
        guard let pressure = pressureService.pressure else { return }
        guard let altitude = pressureService.altitude else { return }
        let weatherRLM = WeatherRLM(pressure: pressure, altitude: altitude, createdDate: Date())
        weatherModel.save(weatherRLM: weatherRLM)
        let weatherLast24h = weatherModel.readLast24h()
        print(weatherLast24h)
    }
    


}


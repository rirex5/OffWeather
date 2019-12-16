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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pressureService.requestAuthorization()
        pressureService.requestAirpessure()
        scheduler.delegate = self
        scheduler.setScheduler(updateInterval: 5)
    }

    func update() {
        print("Pressure: \(pressureService.getPressure())")
        print("SeaLevelPressure: \(pressureService.getSeaLevelPressure())")
    }
    


}


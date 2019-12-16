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
    
    
    @IBOutlet weak var sunnyImageView: UIImageView!
    @IBOutlet weak var cloudyImageView: UIImageView!
    @IBOutlet weak var rainyImageView: UIImageView!
    @IBOutlet weak var weatherSlider: UISlider!
    
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
        let weatherFor24h = weatherModel.readFor24h()
        if let latestWeather = weatherFor24h.last {
            var weatherValue = 0.0
            if latestWeather.seaLevelPressure < 980.0 {
                weatherValue = 0.0
            }
            else if latestWeather.seaLevelPressure > 1040.0 {
                weatherValue = 1.0
            } else {
                weatherValue = ((latestWeather.seaLevelPressure - 980) * (5.0/3.0)) / 100.0
            }
            weatherSlider.value = Float(weatherValue)
            sunnyImageView.alpha = CGFloat(weatherValue)
            rainyImageView.alpha = CGFloat(1.0 - weatherValue)
            if weatherValue >= 0.5 {
                cloudyImageView.alpha = CGFloat(1.5 - weatherValue)
            } else {
                cloudyImageView.alpha = CGFloat(weatherValue + 0.5)
            }
            
        }
    }
    


}


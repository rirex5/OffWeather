//
//  WeatherViewController.swift
//  OffWeather
//
//  Created by Mercury on 2019/12/16.
//  Copyright © 2019 Rirex. All rights reserved.
//

import UIKit
import Charts

class WeatherViewController: UIViewController, SchedulerServiceDelegate {
    
    let pressureService = PressureService.shared
    let scheduler = SchedulerService()
    let weatherModel = WeatherModel()
    
    @IBOutlet weak var sunnyImageView: UIImageView!
    @IBOutlet weak var cloudyImageView: UIImageView!
    @IBOutlet weak var rainyImageView: UIImageView!
    @IBOutlet weak var weatherSlider: UISlider!
    
    
    @IBOutlet weak var seaLevelPressureLabel: UILabel!
    @IBOutlet weak var previousWeatherImageView: UIImageView!
    @IBOutlet weak var nextWeatherImageView: UIImageView!
    @IBOutlet weak var pressureChartView: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    
    func initialization() {
        self.title = "Off Weather"
        self.navigationController?.navigationBar.titleTextAttributes
            = [
                .foregroundColor: UIColor.darkGray,
                .font: UIFont(name: "Futura", size: 20)!
        ]
        
        weatherSlider.setThumbImage(UIImage(systemName: "arrowtriangle.up.fill"), for: .normal)
        initPressureChartView()
        pressureService.requestAuthorization()
        pressureService.requestPressure()
        pressureService.requestLocation()
        scheduler.delegate = self
        scheduler.setScheduler(updateInterval: 10)
    }
    
    func initPressureChartView() {
        pressureChartView.clear()
        // x軸ラベルを下に
        pressureChartView.xAxis.labelPosition = .bottom
        // 軸説明無効
        pressureChartView.legend.enabled = false
        // ズーム無効
        pressureChartView.pinchZoomEnabled = false
        pressureChartView.highlightPerTapEnabled = false
        pressureChartView.dragDecelerationEnabled = false
        pressureChartView.doubleTapToZoomEnabled = false
        // ドラッグ無効
        pressureChartView.dragEnabled = false
        // X,Y方向にズーム可能か
        pressureChartView.scaleXEnabled = false
        pressureChartView.scaleYEnabled = false
        // 最大値と最小値
        // pressureChartView.leftAxis.axisMaximum = 180
        // pressureChartView.leftAxis.axisMinimum = 60
        // 右のラベルの非表示
        pressureChartView.rightAxis.enabled = false
        pressureChartView.drawBordersEnabled = false
        
    }
    
    func update() {
        guard let pressure = pressureService.pressure else { return }
        guard let altitude = pressureService.altitude else { return }
        let weatherRLM = WeatherRLM(pressure: pressure, altitude: altitude, createdDate: Date())
        weatherModel.save(weatherRLM: weatherRLM)
        
        let weatherFor1h = weatherModel.readFor(hour: 1)
        if let latestWeather = weatherFor1h.last {
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
            
            
            if weatherValue >= 0.5 {
                sunnyImageView.alpha = CGFloat((weatherValue - 0.5) * 2.0)
                cloudyImageView.alpha = CGFloat(1.5 - weatherValue)
                rainyImageView.alpha = 0.0
            } else {
                sunnyImageView.alpha = 0.0
                cloudyImageView.alpha = CGFloat(weatherValue + 0.5)
                rainyImageView.alpha = CGFloat(1.0 - weatherValue * 2)
            }
            
        }
        
        let attributes30: [NSAttributedString.Key : Any] = [.font : UIFont(name: "Futura", size: 30.0)!]
        let attributes22: [NSAttributedString.Key : Any] = [.font : UIFont(name: "Futura", size: 22.0)!]
        let seaLevelPressureStr = NSMutableAttributedString()
        seaLevelPressureStr.append(NSAttributedString(string: String(format: "%.2f", weatherRLM.seaLevelPressure), attributes: attributes30))
        seaLevelPressureStr.append(NSAttributedString(string: " hPa", attributes: attributes22))
        seaLevelPressureLabel.attributedText = seaLevelPressureStr
        
        guard let firstSeaLevelPressure = weatherFor1h.first?.seaLevelPressure else {
            return
        }
        guard let lastSeaLevelPressure = weatherFor1h.last?.seaLevelPressure else {
            return
        }
        let span =  lastSeaLevelPressure - firstSeaLevelPressure
        if span > 0 {
            previousWeatherImageView.image = UIImage(systemName: "umbrella.fill")
            nextWeatherImageView.image = UIImage(systemName: "sun.max.fill")
        } else {
            previousWeatherImageView.image = UIImage(systemName: "sun.max.fill")
            nextWeatherImageView.image = UIImage(systemName: "umbrella.fill")
        }
        drawChart(weather1h: weatherFor1h)
        
    }
    
    func drawChart(weather1h: [WeatherRLM]) {
        var entry = [ChartDataEntry]()
        for (i, d) in weather1h.enumerated() {
            entry.append(ChartDataEntry(x: Double(i), y: Double(d.seaLevelPressure) ))
        }
        let dataSet = LineChartDataSet(entries: entry)
        dataSet.colors = [UIColor.lightGray] // [UIColor(red: 0.59, green: 0.67, blue: 0.39, alpha: 1)]
        dataSet.circleColors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)]
        dataSet.circleHoleColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        dataSet.drawValuesEnabled = false
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let chartFormatter = LineChartFormatter(labels: weather1h.map { formatter.string(from: $0.createdDate) })
        let xAxis = pressureChartView.xAxis
        xAxis.valueFormatter = chartFormatter
        xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        xAxis.labelTextColor = UIColor.darkGray
        pressureChartView.xAxis.granularityEnabled = true
        pressureChartView.xAxis.granularity = 1.0
        pressureChartView.xAxis.decimals = 0
        pressureChartView.xAxis.valueFormatter = xAxis.valueFormatter
        pressureChartView.data = LineChartData(dataSet: dataSet)
    }
    
}

private class LineChartFormatter: NSObject, IAxisValueFormatter {
    
    var labels: [String] = []
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if labels.count == 1 {
            return labels[0]
        } else {
            return labels[Int(value)]
        }
    }
    init(labels: [String]) {
        super.init()
        self.labels = labels
    }
}

//
//  SchedulerService.swift
//  OffWeather
//
//  Created by Mercury on 2019/12/16.
//  Copyright © 2019 Rirex. All rights reserved.
//

import Foundation


class SchedulerService: NSObject {
    
    var delegate: SchedulerServiceDelegate?
    var timer: Timer?
    
    func setScheduler(updateInterval: Double) { // time: Sec
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(updateInterval), target: self, selector: #selector(SchedulerService.update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        delegate?.update()
    }
    
    func invalidate() {
        timer?.invalidate()
    }
}

/* Delegate用 */
protocol SchedulerServiceDelegate: NSObjectProtocol {
    func update()
}

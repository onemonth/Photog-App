//
//  NSDate+Extensions.swift
//  Photog
//
//  Created by One Month on 9/16/14.
//  Copyright (c) 2014 One Month. All rights reserved.
//

import Foundation

extension NSDate
{
    func fuzzyTime() -> String
    {
        var secondsInOneDay = CGFloat(60 * 60 * 24)
        var secondsInOneHour = CGFloat(60 * 60)
        
        var seconds = CGFloat(NSDate().timeIntervalSinceDate(self))
        var days = seconds / secondsInOneDay
        var hours = (seconds % secondsInOneDay) / secondsInOneHour
        var minutes = (seconds % secondsInOneHour) / 60
        
        var string = "-"
        
        if (days > 1)
        {
            string = "\(Int(days))d"
        }
        else if (hours > 1)
        {
            string = "\(Int(hours))h"
        }
        else if (minutes > 1)
        {
            string = "\(Int(minutes))m"
        }
        else if (seconds > 1)
        {
            string = "\(Int(seconds))s"
        }
        
        return string
    }
}
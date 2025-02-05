//
//  +Date.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/24.
//

import Foundation

extension Date {
    func toRelativeDateString() -> String {
        let calendar = Calendar.current
        let now = Date()
      
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)
        
        let targetHour = calendar.component(.hour, from: self)
        let targetMinute = calendar.component(.minute, from: self)
        
        let hoursDifference = (currentHour - targetHour) + (currentMinute - targetMinute) / 60
        
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: now)!
        if self < twoDaysAgo {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            return dateFormatter.string(from: self)
        }
        
        if hoursDifference == 0 {
            return "at Now"
        } else if abs(hoursDifference) == 1 {
            return hoursDifference > 0 ? "-1 hour" : "+1 hour"
        } else if abs(hoursDifference) > 1 {
            return "\(hoursDifference > 0 ? "-" : "+")\(abs(hoursDifference)) hours"
        }
        
        return ""
    }
}

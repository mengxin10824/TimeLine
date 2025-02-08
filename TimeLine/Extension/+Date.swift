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
        
        func adjustToHourStart(for date: Date) -> Date {
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
            return calendar.date(from: components)!
        }
        
        let adjustedCurrent = adjustToHourStart(for: Date())
        let adjustedTarget = adjustToHourStart(for: self)
        
        let diffComponents = calendar.dateComponents([.hour], from: adjustedCurrent, to: adjustedTarget)
        guard let diffHours = diffComponents.hour else { return "At Now" }
        
        if abs(diffHours) >= 48 {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d HH:mm"
            return formatter.string(from: adjustedTarget)
        } else {
            switch diffHours {
            case 0:
                return "At Now"
            default:
                let sign = diffHours > 0 ? "+" : "-"
                let absoluteHours = abs(diffHours)
                let hourString = absoluteHours == 1 ? "hour" : "hours"
                return "\(sign)\(absoluteHours) \(hourString)"
            }
        }
    }
}

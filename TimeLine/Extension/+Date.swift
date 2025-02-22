//
//  +Date.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/24.
//

import Foundation

extension Date {
  func toTodayString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    return formatter.string(from: self)
  }
  
  func toPinnedViewString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE MMM d, 'Week' W"
    return formatter.string(from: self)
  }
  
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
        
    if abs(diffHours) >= 12 {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMM d '\n' HH:mm"
      return formatter.string(from: adjustedTarget)
    } else {
      switch diffHours {
      case 0:
        return "At Now"
      default:
        let sign = diffHours > 0 ? "+" : "-"
        let absoluteHours = abs(diffHours)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let dateString = formatter.string(from: adjustedTarget)
        return "\(dateString)\n\(sign)\(absoluteHours) h"
      }
    }
  }
  
  func relativeDateDifference(to date: Date) -> String {
         let totalSeconds = Int(date.timeIntervalSince(self))
         let seconds = abs(totalSeconds)
         
         let days = seconds / (3600 * 24)
         let hours = (seconds % (3600 * 24)) / 3600
         let minutes = (seconds % 3600) / 60
         
         var parts = [String]()
         
         if days > 0 {
             let unit = days == 1 ? "Day" : "Days"
             parts.append("\(days) \(unit)")
         }
         
         if hours > 0 {
             let unit = hours == 1 ? "Hour" : "Hours"
             parts.append("\(hours) \(unit)")
         }
         
         if minutes > 0 || parts.isEmpty {
             parts.append("\(minutes) Minutes")
         }
         
         return parts.joined(separator: " ")
     }
  
  
}

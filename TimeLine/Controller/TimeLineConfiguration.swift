//
//  TimeLineConfiguration.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/27.
//

import Foundation

final class TimeLineConfiguration {
  let hourHeight: CGFloat = 200
  
  let defaultEventHeight: CGFloat = 150
  let defaultEventWidth: CGFloat = 400
  
  let calender: Calendar
  
  var cachedHours: [Date]
  
  func calcEventHeight(event: Event) -> CGFloat {
    guard let startTime = event.startTime, let endTime = event.endTime else {
      return defaultEventHeight
    }
    
    let components = calender.dateComponents([.day, .hour, .minute], from: startTime, to: endTime)
    let offset = (components.day ?? 0) * 24 + (components.hour ?? 0) + (components.minute ?? 0) / 60
    return CGFloat(offset)
  }
  
  func calcEventOffsetY(event: Event) -> CGFloat {
    guard let startTime = event.startTime else {
      return defaultEventHeight
    }
    let components = calender.dateComponents([.minute], from: startTime)
    let offset = (components.minute ?? 0) / 60
    return CGFloat(offset) * hourHeight
  }
  
  init(cal: Calendar = .current) {
    self.calender = cal
    
    let currentHourComponents = cal.startOfDay(for: .now)
    
    var dates: [Date] = []
    for hour in 0 ..< 24 {
      if let newDate = cal.date(byAdding: .hour, value: hour, to: currentHourComponents) {
        dates.append(newDate)
      }
    }
    
    self.cachedHours = dates
  }
}

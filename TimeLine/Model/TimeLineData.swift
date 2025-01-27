//
//  TimeLineData.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/27.
//

import Foundation
import CoreML

struct TimeLineData {
    var allEventType: [EventType] = [.study, .work, .fitness, .life, .leisure, .social, .finance, .creativity]
    
    private var eventIndex: [DateComponents: [Event]] = [:]
    private var otherEvent: [Event] = []
    
    var calendar: Calendar = .current
    
    mutating func addEvent(event: Event) {
        otherEvent.append(event)
    }
    
    mutating func addEventByDay(event: Event, date: Date) {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        eventIndex[components, default: []].append(event)
      
        print("✅ 添加事件: \(event.title) 到日期: \(components)")
    }
    
    func getEventsByHour(for hour: Date) -> [Event] {
        let components = calendar.dateComponents([.year, .month, .day], from: hour)
        guard let dailyEvents = eventIndex[components] else { return [] }
        
        return dailyEvents.filter { event in
          print("✅ 获取事件: \(event.title) 到日期: \(components)")
          return calendar.isDate(event.startTime!, equalTo: hour, toGranularity: .hour)
        }
    }
  
  
  // MARK: - Predict Event Type
  func predictEventType(from text: String) -> EventType? {
    do {
      let config = MLModelConfiguration()
      let model = try EventClassify(configuration: config)

      let input = EventClassifyInput(text: text)

      let prediction = try model.prediction(input: input)

      let eventTypeName = prediction.label

      return allEventType.first { $0.name == eventTypeName.uppercased() }
    } catch {
      print("Error predicting event type: \(error.localizedDescription)")
      return nil
    }
  }
  
  init() {
    
  }
}

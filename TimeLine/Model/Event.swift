//
//  Event.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/19.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Event: Identifiable {
  static var allEventType: [EventType] = [
    .study, .work, .fitness, .life, .leisure, .social, .finance, .creativity,
  ]

  var id: UUID
  var title: String
  var details: String

  // type of event
  var eventType: EventType

  // time
  var createdTime: Date
  var startTime: Date?
  var endTime: Date?

  // isSubEvent
  weak var parentOfEvent: Event?
  var subEvents: [Event] = []
  func addSubEvent(_ event: Event) {
    self.subEvents.append(event)
    event.parentOfEvent = self
  }

  
  init(
    title: String, details: String, eventType: EventType, createdTime: Date, startTime: Date? = nil,
    endTime: Date? = nil
  ) {
    self.id = UUID()
    self.title = title
    self.details = details
    self.eventType = eventType
    self.createdTime = createdTime
    self.startTime = startTime
    self.endTime = endTime
  }
}

// demo data
extension Event {
  public static var demoEvents: [Event] = {
    var events = [Event]()

    // 创建15个普通事件
    for i in 1...15 {
      let event = Event(
        title: "Event \(i)",
        details: "Details for event \(i)",
        eventType: Event.allEventType.randomElement()!,
        createdTime: Date(),
        startTime: Date().addingTimeInterval(Double(i) * 1000),
        endTime: Date().addingTimeInterval(Double(i) * 2000)
      )
      events.append(event)
    }

    // 创建5个包含子事件的父事件
    for i in 16...20 {
      let parentEvent = Event(
        title: "Parent Event \(i)",
        details: "Details for parent event \(i)",
        eventType: Event.allEventType.randomElement()!,
        createdTime: Date(),
        startTime: Date().addingTimeInterval(Double(i) * 1000),
        endTime: Date().addingTimeInterval(Double(i) * 2000)
      )
      let subEvent1 = Event(
        title: "Sub Event \(i)-1",
        details: "Details for sub event \(i)-1",
        eventType: Event.allEventType.randomElement()!,
        createdTime: Date(),
        startTime: Date().addingTimeInterval(Double(i + 1) * 1000),
        endTime: Date().addingTimeInterval(Double(i + 1) * 2000)
      )
      let subEvent2 = Event(
        title: "Sub Event \(i)-2",
        details: "Details for sub event \(i)-2",
        eventType: Event.allEventType.randomElement()!,
        createdTime: Date(),
        startTime: Date().addingTimeInterval(Double(i + 2) * 1000),
        endTime: Date().addingTimeInterval(Double(i + 2) * 2000)
      )
      parentEvent.subEvents.append(contentsOf: [subEvent1, subEvent2])
      events.append(parentEvent)
    }

    return events
  }()
}

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
  @Attribute(.unique) var id: UUID = UUID()
  var title: String
  var details: String

  // type of event
  var eventType: EventType

  // time
  var createdTime: Date = Date()
  var startTime: Date?
  var endTime: Date?
  var duration: String? {
    if let start = startTime, let end = endTime {
      return start.relativeDateDifference(to: end)
    } else {
      return nil
    }
  }
  

  // importance
  var importance: Int = 0
  var priorityText: String {
    switch self.importance {
    case 0:
      return "Low"
    case 1:
      return "Normal"
    case 2:
      return "High"
    default:
      return ""
    }
  }

  // isSubEvent
  @Relationship(inverse: \Event.subEvents)
  weak var parentOfEvent: Event?

  @Relationship(deleteRule: .cascade)
  var subEvents: [Event] = []
  
  
  var isCompleted: Bool = false

  init(title: String, details: String, eventType: EventType, startTime: Date? = nil, endTime: Date? = nil, importance: Int = 0, parentOfEvent: Event? = nil) {
    self.title = title
    self.details = details
    self.eventType = eventType
    
    self.startTime = startTime
    self.endTime = endTime
    
    self.importance = importance
    
    self.parentOfEvent = parentOfEvent
  }
  
  func addSubEvent(_ event: Event) {
    self.subEvents.append(event)
    event.parentOfEvent = self
  }

}

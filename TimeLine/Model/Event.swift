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

  // importance
  var importance: Int = 0

  // isSubEvent
  @Relationship(inverse: \Event.subEvents)
  weak var parentOfEvent: Event?

  @Relationship(deleteRule: .cascade)
  var subEvents: [Event] = []

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

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

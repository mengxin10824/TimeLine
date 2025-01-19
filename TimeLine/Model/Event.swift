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
class Event: Identifiable {
  public var id: UUID
  var title: String
  var details: String

  // type of event
  var eventType: EventType

  // time
  var createdTime: Date
  var startTime: Date?
  var endTime: Date?

  // long term event (minutes)
  var durationTime: UInt?

  // isSubEvent
  weak var parentOfEvent: Event?
  var subEvents: [Event] = []

  init(title: String, details: String, eventType: EventType, createdTime: Date, startTime: Date? = nil, endTime: Date? = nil, durationTime: UInt? = nil) {
          self.id = UUID()
          self.title = title
          self.details = details
          self.eventType = eventType
          self.createdTime = createdTime
          self.startTime = startTime
          self.endTime = endTime
          self.durationTime = durationTime
      }
}


// Demo Datas
extension Event {
    public static var demoEvents: [Event] = [
       
    ]
}

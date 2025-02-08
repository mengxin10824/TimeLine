//
//  TimeLineMainView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

import SwiftData
import SwiftUI

struct TimeLineMainView: View {
  let hourHeight: CGFloat = 200
  
  let defaultEventHeight: CGFloat = 150
  let defaultEventWidth: CGFloat = 400
  
  let calendar: Calendar = .current
  let hour: Date
  
  @Query(
    filter: #Predicate<Event> {
      $0.startTime != nil && $0.endTime != nil
    },
    sort: \Event.startTime,
    order: .forward
  )
  private var allEvents: [Event]
  
  var body: some View {
    let eventsInThisHour = events(atHour: hour)
    HStack(alignment: .top, spacing: 8) {
      // TimeLine Bar
      TimeLineMainBarView(currentTime: hour)
        .frame(
          width: 20,
          height: eventsInThisHour.count == 0 ? 30 : self.hourHeight
        )
      
      VStack {
        ForEach(eventsInThisHour, id: \.id) { event in
          EventBlockView(event: event)
            .frame(width: 100, height: self.calcEventHeight(event: event))
            .offset(y: self.calcEventOffsetY(event: event))
        }
      }
      .frame(maxWidth: .infinity)
    }
  }

  private func calcEventHeight(event: Event) -> CGFloat {
    guard let startTime = event.startTime, let endTime = event.endTime else {
      return defaultEventHeight
    }
    
    let components = calendar.dateComponents([.day, .hour, .minute], from: startTime, to: endTime)
    let offset = (components.day ?? 0) * 24 + (components.hour ?? 0) + (components.minute ?? 0) / 60
    return CGFloat(offset)
  }
  
  private func calcEventOffsetY(event: Event) -> CGFloat {
    guard let startTime = event.startTime, let _ = event.endTime else {
      return defaultEventHeight
    }
    let components = calendar.dateComponents([.minute], from: startTime)
    let offset = (components.minute ?? 0) / 60
    guard offset < 0 else {
      return 0
    }
    return CGFloat(offset) * hourHeight
  }
  
  private func events(atHour date: Date) -> [Event] {
    guard let startOfHour = calendar.date(
      from: calendar.dateComponents([.year, .month, .day, .hour], from: date)
    ),
      let endOfHour = calendar.date(byAdding: .hour, value: 1, to: startOfHour)
    else {
      return []
    }
      
    return allEvents.filter { event in
      guard let start = event.startTime else {
        return false
      }
      return start >= startOfHour && start < endOfHour
    }
  }
}

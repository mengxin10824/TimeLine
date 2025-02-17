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
      TimeLineMainBarView(hour: hour)
        .frame(height: hourHeight)
      
      ZStack {
        ForEach(Array(eventsInThisHour.enumerated()), id: \.offset) { index, event in
          EventBlockView(event: event)
            .overlay(alignment: .leading) {
              VStack {
                timeView(time: event.startTime).offset(y: -20)
                Spacer()
                timeView(time: event.endTime).offset(y: 20)
              }
            }
            .frame(width: 200, height: self.calcEventHeight(event: event))
            .offset(x: CGFloat(index * 20), y: self.calcEventOffsetY(event: event))
            .zIndex(Double(index))
        }
      }
      .offset(x: 80)
      .frame(width: 0, height: hourHeight, alignment: .topLeading)
        
      Spacer()
    }
  }
  
  private func timeView(time: Date?) -> some View {
    if let time = time {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      let timeString = dateFormatter.string(from: time)

      return AnyView(
        Text(timeString)
          .font(.system(size: 14, weight: .light))
          .foregroundStyle(.secondary)
      )
    } else {
      return AnyView(EmptyView())
    }
  }

  private func calcEventHeight(event: Event) -> CGFloat {
    guard let startTime = event.startTime, let endTime = event.endTime else {
      return defaultEventHeight
    }
    
    let timeInterval = endTime.timeIntervalSince(startTime)
    let offset = timeInterval / 3600
    
    guard offset > 0 else {
      return defaultEventHeight
    }
    return CGFloat(offset) * hourHeight
  }
  
  private func calcEventOffsetY(event: Event) -> CGFloat {
    guard let startTime = event.startTime, let _ = event.endTime else {
      return defaultEventHeight
    }
    
    let components = calendar.dateComponents([.minute], from: startTime)
    let offset = (components.minute ?? 0) / 60
    guard offset > 0 else {
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
      
    return allEvents
      .filter { event in
        guard let start = event.startTime else {
          return false
        }
        return start >= startOfHour && start < endOfHour
      }
      .sorted { $0.startTime! > $1.startTime! }
  }
}

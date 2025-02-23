//
//  TimeLineMainView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

import SwiftData
import SwiftUI

struct TimeLineMainView: View {
  @State var hour: Date
  var events: [Event] {
    var allEvents = viewModel.events(atHour: hour)
    return withAnimation(.easeInOut(duration: 0.3)) {
      switch filterType {
      case .byPriority:
        allEvents.sort { $0.importance > $1.importance }
        
      case .byType:
        allEvents.sort { $0.eventType.name < $1.eventType.name }
        
      case .byTime:
        allEvents.sort {
          guard let s0 = $0.startTime, let s1 = $1.startTime else { return false }
          return s0 < s1
        }

      case .none:
        allEvents.sort { $0.createdTime < $1.createdTime }
      }
      return allEvents
    }
  }
  
  @Environment(\.filterType) var filterType: FilterType
  @EnvironmentObject var viewModel: ViewModel
  
  let hourHeight: CGFloat = 200
  
  let defaultEventHeight: CGFloat = 150
  let defaultEventWidth: CGFloat = 400
  
  let calendar: Calendar = .current
  
  let eventsInThisHour: [Event] = []
  
  var body: some View {
    HStack(alignment: .top, spacing: 8) {
      TimeLineMainBarView(hour: hour)
        .frame(height: hourHeight, alignment: .leading)
      
      ZStack(alignment: .leading) {
        ForEach(Array(events.enumerated()), id: \.offset) { index, event in
          VStack {
            EventBlockView(event: event)
              .frame(minHeight: self.calcEventHeight(event: event))
              .overlay(alignment: .leading, content: {
                VStack {
                  timeView(time: event.startTime).offset(y: -15)
                  Spacer()
                  timeView(time: event.endTime).offset(y: 15)
                }
              })
              .offset(x: CGFloat(index * 250 + 60), y: self.calcEventOffsetY(event: event))
              .zIndex(Double(index))
              .transition(.move(edge: .leading))
              .fixedSize()
              .frame(height: 0)
          }
        }
        
      }
      .id(filterType)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.leading, 5)
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
}

//
//  TimeLineMainView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

import SwiftData
import SwiftUI

// struct TimeLineMainView: View {
//  @State var config = TimeLineConfiguration()
//  @Environment(\.modelContext) private var modelContext
//  var calendar = Calendar.current
//
//  // MARK: - 优化布局
//
//  var body: some View {
//    ScrollView([.vertical]) {
//      ScrollViewReader { proxy in
//        LazyVStack(alignment: .leading, spacing: 0) {
//          ForEach(config.cachedHours, id: \.self) { hour in
//            HStack(alignment: .top, spacing: 30) {
//              TimeLineMainBarView(currentTime: hour)
//                .frame(width: 25, height: config.hourHeight)
//
//              VStack {
//                ForEach(fetchEvents(atHour: hour), id: \.id) { event in
//                  TimeLineMainEventBlockView(event: event)
//                    .frame(width: 170, height: config.calcEventHeight(event: event))
//                    .offset(y: config.calcEventOffsetY(event: event))
//                }
//              }.frame(maxWidth: .infinity)
//            }.id(hour)
//          }
//        }
//        .onAppear {
//          let currentHour = Calendar.current.component(.hour, from: Date())
//          if let targetHour = config.cachedHours.first(where: { Calendar.current.component(.hour, from: $0) == currentHour }) {
//            proxy.scrollTo(targetHour, anchor: .center)
//
//          }
//        }
//      }
//    }
//    .scrollIndicators(.hidden)
//    .ignoresSafeArea()
//  }
//
//  func fetchEvents(inDay day: Date) -> [Event] {
//    let startOfDay = calendar.startOfDay(for: day)
//    guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)
//    else { return [] }
//
//    let predicate = #Predicate<Event> {
//      ($0.startTime != nil && $0.endTime != nil) ?
//        ($0.startTime! < endOfDay && $0.endTime! > startOfDay) :
//        false
//    }
//
//    let descriptor = FetchDescriptor(
//      predicate: predicate
//    )
//
//    do {
//      return try modelContext.fetch(descriptor)
//    } catch {
//      print("Fetch error: \(error)")
//      return []
//    }
//  }
//
//  func fetchEvents(atHour date: Date) -> [Event] {
//    guard let startOfHour = calendar.date(
//      from: calendar.dateComponents([.year, .month, .day, .hour], from: date)
//    ),
//      let endOfHour = calendar.date(byAdding: .hour, value: 1, to: startOfHour)
//    else { return [] }
//
//    let predicate = #Predicate<Event> {
//      ($0.startTime != nil && $0.endTime != nil) ?
//        ($0.startTime! < endOfHour && $0.endTime! > startOfHour) :
//        false
//    }
//
//    let descriptor = FetchDescriptor<Event>(
//      predicate: predicate
//    )
//
//    return (try? modelContext.fetch(descriptor)) ?? []
//  }
// }

struct TimeLineMainView: View {
  let hourHeight: CGFloat = 200
  
  let defaultEventHeight: CGFloat = 150
  let defaultEventWidth: CGFloat = 400
  
  let calendar: Calendar
  var cachedHours: [Date]
  
  @State private var queryString = ""

  @Query(
    filter: #Predicate<Event> {
      $0.startTime != nil && $0.endTime != nil
    },
    sort: \Event.startTime,
    order: .forward
  )
  private var allEvents: [Event]
  
  init(cal: Calendar = .current) {
    self.calendar = cal
    
    let currentHourComponents = cal.startOfDay(for: .now)
    
    var dates: [Date] = []
    for hour in 0 ..< 24 {
      if let newDate = cal.date(byAdding: .hour, value: hour, to: currentHourComponents) {
        dates.append(newDate)
      }
    }
    self.cachedHours = dates
  }
  
  var body: some View {
    ScrollView([.vertical]) {
      ScrollViewReader { proxy in
        LazyVStack(alignment: .leading, spacing: 0) {
          ForEach(self.cachedHours, id: \.self) { hour in
            HStack(alignment: .top, spacing: 8) {
              TimeLineMainBarView(currentTime: hour)
                .frame(width: 20, height: self.hourHeight)

              let eventsInThisHour = events(atHour: hour)
              VStack {
                ForEach(eventsInThisHour, id: \.id) { event in
                  EventBlockView(event: event)
                    .frame(width: 100, height: self.calcEventHeight(event: event))
                    .offset(y: self.calcEventOffsetY(event: event))
                }
              }.frame(maxWidth: .infinity)
            }.id(hour)
          }
        }
        .onAppear {
          let currentHour = calendar.component(.hour, from: Date())
          if let targetHour = self.cachedHours.first(where: {
            calendar.component(.hour, from: $0) == currentHour
          }) {
            proxy.scrollTo(targetHour, anchor: .center)
          }
        }
      }
    }
    .scrollIndicators(.hidden)
    .ignoresSafeArea()
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

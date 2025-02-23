//
//  TodayScrollView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/2/8.
//

import SwiftUI

struct TodayScrollView: View {
  private let calendar: Calendar = .current
  private let hoursPerDay = 24
    
  @State private var isLoadingUp = false
  @State private var isLoadingDown = false
  
  @State private var cachedHours: [Date]
  @State private var visibleHours = Set<Date>()
  
  @State var currentDate: Date = .now
  
  @Binding var isBackToNow: Bool
  @EnvironmentObject var viewModel: ViewModel
  
  init(isBackToNow: Binding<Bool>) {
      self._isBackToNow = isBackToNow
      
      let todayStart = calendar.startOfDay(for: .now)
      var dates: [Date] = []
      
      for dayOffset in -1...1 {
        let newDayStart = calendar.date(byAdding: .day, value: dayOffset, to: todayStart)!
          
        for hour in 0..<hoursPerDay {
          if let newDate = calendar.date(byAdding: .hour, value: hour, to: newDayStart) {
            dates.append(newDate)
          }
        }
      }

    self.cachedHours = dates
  }
  
  var body: some View {
    GeometryReader { reader in
      ScrollView([.horizontal, .vertical]) {
        ScrollViewReader { proxy in
          LazyVStack(spacing: 0) {
            ForEach(cachedHours, id: \.self) { hour in
              let events = viewModel.events(atHour: hour)
              TimeLineMainView(events: events, hour: hour)
                .frame(width: reader.size.width * 1.3)
                .id(hour)
                .onAppear {
                  handleAppear(hour: hour, proxy: proxy)
                }
                .onDisappear {
                  visibleHours.remove(hour)
                }
            }
          }
          .onAppear {
            // Scroll to Now
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              scrollToCurrentHour(proxy: proxy)
            }
          }
          .onChange(of: isBackToNow) { _, isBackToNow in
            if isBackToNow {
              scrollToCurrentHour(proxy: proxy, animation: .easeInOut)
              self.isBackToNow = false
            }
          }
        }
      }
      .background(.gray.opacity(0.1))
      .scrollIndicators(.hidden)
      .defaultScrollAnchor(.init(x: 0, y: 0.5))
      .navigationTitle(currentDate.toPinnedViewString())
      .navigationBarTitleDisplayMode(.inline)
    }
  }
  
  private func handleAppear(hour: Date, proxy: ScrollViewProxy) {
    visibleHours.insert(hour)
    currentDate = hour
      
    if let firstCached = cachedHours.first, hour == firstCached && !isLoadingUp {
      loadMoreUp(proxy: proxy)
    }
      
    if let lastCached = cachedHours.last, hour == lastCached && !isLoadingDown {
      loadMoreDown(proxy: proxy)
    }
  }
  
  private func loadMoreUp(proxy: ScrollViewProxy) {
    guard !isLoadingUp else { return }
    isLoadingUp = true
      
    guard let originalFirstHour = cachedHours.first else {
      isLoadingUp = false
      return
    }
      
    let newDayStart = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: originalFirstHour))!
    var newHours: [Date] = []
      
    for hour in 0..<hoursPerDay {
      if let newDate = calendar.date(byAdding: .hour, value: hour, to: newDayStart) {
        newHours.append(newDate)
      }
    }
      
    DispatchQueue.main.async {
      cachedHours.insert(contentsOf: newHours, at: 0)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        proxy.scrollTo(originalFirstHour, anchor: .top)
      }
      isLoadingUp = false
    }
  }
  
  private func loadMoreDown(proxy: ScrollViewProxy) {
    guard !isLoadingDown else { return }
    isLoadingDown = true
      
    guard let originalLastHour = cachedHours.last else {
      isLoadingDown = false
      return
    }
      
    let newDayStart = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: originalLastHour))!
    var newHours: [Date] = []
      
    for hour in 0..<hoursPerDay {
      if let newDate = calendar.date(byAdding: .hour, value: hour, to: newDayStart) {
        newHours.append(newDate)
      }
    }
      
    DispatchQueue.main.async {
      cachedHours.append(contentsOf: newHours)
      isLoadingDown = false
    }
  }

  private func scrollToCurrentHour(proxy: ScrollViewProxy, animation: Animation? = nil) {
    let currentHour = calendar.dateComponents([.hour], from: Date()).hour!
    if let targetHour = cachedHours.first(where: {
      calendar.component(.hour, from: $0) == currentHour &&
        calendar.isDate($0, inSameDayAs: Date())
    }) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        withAnimation(animation) {
          proxy.scrollTo(targetHour, anchor: .leading)
        }
      }
    }
  }
    
  private func shouldShowLoadingIndicator(for hour: Date) -> Bool {
    (hour == cachedHours.first && isLoadingUp) ||
      (hour == cachedHours.last && isLoadingDown)
  }
    
  private func isCurrentHour(_ date: Date) -> Bool {
    calendar.isDate(date, equalTo: Date(), toGranularity: .hour)
  }
}

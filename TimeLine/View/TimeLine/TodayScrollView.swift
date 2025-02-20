//
//  TodayScrollView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/2/8.
//

import SwiftUI

struct TodayScrollView: View {
  private let calendar: Calendar
  private let prefetchThreshold = 5
  private let hoursPerDay = 24
    
  @State private var isLoadingUp = false
  @State private var isLoadingDown = false
  
  @State private var cachedHours: [Date]
  @State private var visibleHours = Set<Date>()
  
  @State var currentDate: Date = .now
  
  @Binding var isBackToNow: Bool
  @Binding var filterType: FilterType
  
  init(isBackToNow: Binding<Bool>, filterType: Binding<FilterType>) {
    self.calendar = .current
    let todayStart = calendar.startOfDay(for: .now)
    var dates: [Date] = []
        
    // Init cache hours array
    for dayOffset in -1 ... 1 {
      guard let dayStart = calendar.date(byAdding: .day, value: dayOffset, to: todayStart) else { continue
      }
            
      for hour in 0..<hoursPerDay {
        if let newDate = calendar.date(byAdding: .hour, value: hour, to: dayStart) {
          dates.append(newDate)
        }
      }
    }
    self.cachedHours = dates
    
    self._isBackToNow = isBackToNow
    self._filterType = filterType
  }

  var body: some View {
    ScrollView {
      ScrollViewReader { proxy in
        LazyVStack(spacing: 0) {
          ForEach(cachedHours, id: \.self) { hour in
            TimeLineMainView(hour: hour)
              .padding(.leading, 20)
              .id(hour)
              .onAppear {
                handleAppear(hour: hour, proxy: proxy)
              }
              .onDisappear {
                visibleHours.remove(hour)
              }
          }
        }
        .padding(.vertical)
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
        .onChange(of: filterType) { oldValue, newValue in
          if oldValue != .none && newValue != .none {
            
          } else if newValue == FilterType.byPriority {
            
          } else if newValue == FilterType.byTime {
            
          } else if newValue == FilterType.byPriority {
            
          }
          self.filterType = .none
        }
      }
    }
    .background(.gray.opacity(0.1))
    .scrollIndicators(.hidden)
    .navigationTitle(currentDate.toPinnedViewString())
  }

  private func handleAppear(hour: Date, proxy: ScrollViewProxy) {
    visibleHours.insert(hour)
    currentDate = hour
        
    if cachedHours.prefix(prefetchThreshold).contains(hour) && !isLoadingUp {
      loadMoreUp(proxy: proxy)
    }
        
    if cachedHours.suffix(prefetchThreshold).contains(hour) && !isLoadingDown {
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
      proxy.scrollTo(originalFirstHour, anchor: .top)
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
      withAnimation(animation) {
        proxy.scrollTo(targetHour, anchor: .center)
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

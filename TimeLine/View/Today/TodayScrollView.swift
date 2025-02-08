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
    
    init(calendar: Calendar = .current) {
        self.calendar = calendar
        
        let todayStart = calendar.startOfDay(for: .now)
        var dates: [Date] = []
        
        for dayOffset in -1...1 {
            guard let dayStart = calendar.date(byAdding: .day, value: dayOffset, to: todayStart) else { continue }
            
            for hour in 0..<hoursPerDay {
                if let newDate = calendar.date(byAdding: .hour, value: hour, to: dayStart) {
                    dates.append(newDate)
                }
            }
        }
        self.cachedHours = dates
    }
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVStack(spacing: 0) {
                    ForEach(cachedHours, id: \.self) { hour in
                      TimeLineMainView(hour: hour)
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
                    scrollToCurrentHour(proxy: proxy)
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    
    private func handleAppear(hour: Date, proxy: ScrollViewProxy) {
        visibleHours.insert(hour)
        
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
          withAnimation(.none) {
                cachedHours.insert(contentsOf: newHours, at: 0)
            }
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
          withAnimation(.none) {
                cachedHours.append(contentsOf: newHours)
            }
            isLoadingDown = false
        }
    }
    
    private func scrollToCurrentHour(proxy: ScrollViewProxy) {
        let currentHour = calendar.dateComponents([.hour], from: Date()).hour!
        if let targetHour = cachedHours.first(where: {
            calendar.component(.hour, from: $0) == currentHour &&
            calendar.isDate($0, inSameDayAs: Date())
        }) {
            proxy.scrollTo(targetHour, anchor: .center)
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

#Preview {
    TodayScrollView()
}

//
//  TimeLineMainView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

import SwiftUI

struct TimeLineMainView: View {
    @State var events: [Event]

    // Hour Height
    let defaultHourHeight: CGFloat = 100

    // Event Block Frame
    let defaultEventHeight: CGFloat = 200
    let defaultEventWidth: CGFloat = 300

    // Configure the time line
    let calendar: Calendar = .current

    // MARK: - TimeLine Hours
    func getTimeLineHours(hours: Int = 24) -> [Date] {
        var result: [Date] = []
        let currentHour = calendar.date(from: calendar.dateComponents([.hour], from: .now)) ?? .now

        for hour in stride(from: hours, to: 0, by: -1) {
            let currentDate = calendar.date(byAdding: .hour, value: -hour, to: currentHour) ?? .now
            result.append(currentDate)
        }
        for hour in stride(from: 0, to: hours, by: 1) {
            let currentDate = calendar.date(byAdding: .hour, value: hour, to: currentHour) ?? .now
            result.append(currentDate)
        }
        return result
    }

    // Calculate the event from current time
    func getCurrentEvent(currentTime: Date) -> [Event] {
        var result: [Event] = []
        for event in events {
            guard let startTime = event.startTime else {
                result.append(event)
                continue
            }
            if calendar.isDate(currentTime, equalTo: startTime, toGranularity: .hour) {
                result.append(event)
            }
        }
        return result
    }

    // Calculate the event block offset
    func getEventBlockOffsetY(event: Event, currentTime: Date) -> CGFloat? {
        guard let start = event.startTime else { return nil }
        let components = calendar.dateComponents([.hour, .minute], from: start, to: currentTime)
        let hours = CGFloat(components.hour ?? 0) + CGFloat(components.minute ?? 0) / 60
        if hours <= 0 {
            return nil
        }
        return hours * defaultHourHeight
    }

    // Calculate the event block height
    func getEventBlockHeight(event: Event) -> CGFloat {
        guard let start = event.startTime, let end = event.endTime else { return defaultEventHeight }
        let components = calendar.dateComponents([.hour, .minute], from: start, to: end)
        let hours = CGFloat(components.hour ?? 0) + CGFloat(components.minute ?? 0) / 60
        return hours * defaultHourHeight
    }


    // MARK: - The Main View
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            LazyVStack(alignment: .leading, spacing: 0) {
                let timelineHours = Array(getTimeLineHours().enumerated())
                ForEach(timelineHours, id: \.offset) { index, hour in
                    HStack(alignment: .top) {
                      TimeLineMainBarView( currentTime: hour, events: $events, index: index)
                            .frame(width: 25, height: defaultHourHeight)
                        Spacer(minLength: 25)
                        ForEach(getCurrentEvent(currentTime: hour)) { event in
                          TimeLineMainEventBlockView(event: event)
                                .frame(width: 200)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    TimeLineMainView(events: Event.demoEvents)
}

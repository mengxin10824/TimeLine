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

    @ViewBuilder
    func BarView(index: Int, currentTime: Date) -> some View {
        ZStack(alignment: .bottomTrailing) {
            BarBackgroundView(index: index)
            Text(currentTime.description)
                .font(.caption)
                .fixedSize()
                .position(x: 50)
        }
    }

    // MARK: - The shape of the bar
    func BarBackgroundView(index: Int) -> some Shape {
        if index == 0 {
            return AnyShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: .infinity, bottomLeadingRadius: 0, bottomTrailingRadius: 0,
                    topTrailingRadius: .infinity, style: .continuous))
        } else if index == events.count - 1 {
            return AnyShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 0, bottomLeadingRadius: .infinity, bottomTrailingRadius: .infinity,
                    topTrailingRadius: 0, style: .continuous))
        } else {
            return AnyShape(Rectangle())
        }
    }

    // MARK: - The View of the Event
    @ViewBuilder
    func EventBlockView(event: Event) -> some View {
        ZStack {
            Circle()
                .frame(width: 100)
                .position()
            VStack {
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(event.title)
                            .font(.title2)

                        Text(event.details)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(3...5)
                    }
                }
                Spacer()
                HStack {
                    VStack {
                        Text("Event Type")
                            .font(.caption)
                        Text(event.eventType.name)
                            .font(.title3)
                    }
                    Spacer()
                    VStack {
                        Text("Priority")
                            .font(.caption)
                        Text("11")
                            .font(.title3)
                    }
                    Spacer()
                    VStack {
                        Text("Event Type")
                            .font(.caption)
                        Text("22")
                            .font(.title3)
                    }
                }

                Spacer()
                ForEach(event.subEvents) { event in
                    Rectangle().frame(height: 1)
                    HStack {
                        Text(event.title)
                        Spacer()
                    }.padding(.vertical, 5)
                }
            }
        }
        .padding()
        .frame(minWidth: 300, minHeight: 200)
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
        .contextMenu(
            menuItems: {
                Label("1", systemImage: "circle")
            },
            preview: {
                Text("Preview")
            })
    }

    // MARK: - The Main View
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            LazyVStack(alignment: .leading, spacing: 0) {
                let timelineHours = Array(getTimeLineHours().enumerated())
                ForEach(timelineHours, id: \.offset) { index, hour in
                    HStack(alignment: .top) {
                        BarView(index: index, currentTime: hour)
                            .frame(width: 25, height: defaultHourHeight)
                        Spacer(minLength: 25)
                        ForEach(getCurrentEvent(currentTime: hour)) { event in
                            EventBlockView(event: event)
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

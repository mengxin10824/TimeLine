//
//  TimeLineMainEventBlockView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/25.
//
import SwiftUI

struct EventBlockView: View {
  @State var event: Event

  var body: some View {
    let tintColor: Color = event.eventType.color

      VStack(alignment: .trailing, spacing: 8) {
        EventTitleView(title: event.title, tintColor: tintColor)
        if !event.details.isEmpty {
          EventDetailsView(details: event.details, tintColor: tintColor)
        }
        EventInfoView(event: event, tintColor: tintColor)
      }
      .padding(20)
      .background(tintColor.opacity(0.1))
      .clipShape(RoundedRectangle(cornerRadius: 15))
      .contextMenu(
        menuItems: {
          Label("1", systemImage: "circle")
        },
        preview: {
          EventBlockPreview(event: event, tintColor: tintColor)
        }
      )
      .frame(minWidth: 300, minHeight: 70)
  }

  private func priorityText(for importance: Int) -> String {
    switch importance {
    case 0:
      return "Low"
    case 1:
      return "Normal"
    case 2:
      return "High"
    default:
      return ""
    }
  }
}

struct EventTitleView: View {
  let title: String
  let tintColor: Color

  var body: some View {
    Text(title)
      .font(.system(size: 34, weight: .black))
      .foregroundColor(tintColor.opacity(0.75))
  }
}

struct EventDetailsView: View {
  let details: String
  let tintColor: Color

  var body: some View {
    Text(details)
      .lineLimit(1 ... 3)
      .font(.system(size: 26, weight: .bold))
      .multilineTextAlignment(.trailing)
      .foregroundStyle(tintColor.opacity(0.35))
  }
}

struct EventInfoView: View {
  let event: Event
  let tintColor: Color

  var body: some View {
    HStack {
      InfoItemView(label: "Event Type", value: event.eventType.name.uppercased(), tintColor: tintColor)
      InfoItemView(label: "Priority", value: priorityText(for: event.importance).uppercased(), tintColor: tintColor)
      InfoItemView(label: "subEvent", value: event.subEvents.count.description, tintColor: tintColor)
    }
    .padding(15)
    .frame(maxWidth: .infinity, maxHeight: 100)
    .background(tintColor.opacity(0.1))
    .clipShape(RoundedRectangle(cornerRadius: 25))
    .padding(.vertical, 10)
  }

  private func priorityText(for importance: Int) -> String {
    switch importance {
    case 0:
      return "Low"
    case 1:
      return "Normal"
    case 2:
      return "High"
    default:
      return ""
    }
  }
}

struct InfoItemView: View {
  let label: String
  let value: String
  let tintColor: Color

  var body: some View {
    VStack {
      Text(label)
        .font(.system(size: 14, weight: .black))
        .foregroundColor(tintColor.opacity(0.4))
        .fixedSize()
      Spacer()
      Text(value)
        .font(.system(size: 16, weight: .black))
        .foregroundColor(tintColor.opacity(0.5))
        .fixedSize()
    }
  }
}

struct SubEventsView: View {
  let subEvents: [Event]
  let tintColor: Color

  var body: some View {
    VStack {
      ForEach(Array(subEvents.prefix(2).enumerated()), id: \.offset) { index, subEvent in
        Rectangle()
          .fill(.clear)
          .frame(height: 2)
          .background(tintColor.opacity(0.2))
        HStack {
          Text("\(index + 1). ")
          Text(subEvent.title).lineLimit(1)
          Spacer()
        }
        .padding(.horizontal)
      }

      if subEvents.count > 2 {
        Rectangle()
          .fill(.clear)
          .frame(height: 2)
          .background(tintColor.opacity(0.2))
        Text("And More \(subEvents.count - 2) Event...")
          .padding(.bottom)
      }
    }
    .font(.system(size: 14, weight: .black))
    .foregroundColor(tintColor.opacity(0.3))
  }
}

struct EventBlockPreview: View {
  let event: Event
  let tintColor: Color
  
  var body: some View {
    VStack(spacing: 0) {
      EventBlockView(event: event)
      SubEventsView(subEvents: event.subEvents, tintColor: event.eventType.color)
        .background(tintColor.opacity(0.1))
        .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 20, bottomTrailingRadius: 20))
        .padding(.horizontal)
    }
  }
}

#Preview {
  let event = Event(title: "Title", details: "Details", eventType: EventType(name: "STUDY", hexString: "#E34343"), importance: 1)
  event.addSubEvent(Event(title: "1", details: "1", eventType: EventType(name: "STUDY", hexString: "#E34343")))
  event.addSubEvent(Event(title: "1akbhdjkasbvjdbajdbasbdjksbdkadasbjdbjksad", details: "1", eventType: EventType(name: "STUDY", hexString: "#E34343")))
  event.addSubEvent(Event(title: "1", details: "1", eventType: EventType(name: "STUDY", hexString: "#E34343")))

  return EventBlockView(event: event)
    .frame(width: 200, height: 300)
}

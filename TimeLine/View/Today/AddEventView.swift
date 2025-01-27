//
//  AddEventView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/22.
//

import SwiftUI

struct AddEventView: View {
//  @Binding var data: TimeLineData = TimeLineData()
  
  
  @State var event: Event = Event(title: "", details: "", eventType: .study, createdTime: .now)
  @State private var hasTime: Bool = false

  var body: some View {
    Form {
      Section("Event Detail") {
        HStack(alignment: .top) {
          Label("Title", systemImage: "note.text")
          TextField("Enter title", text: $event.title)
            .lineLimit(3...5)
        }

        VStack {
          HStack {
            Label("Details", systemImage: "info.circle")
            Spacer()
          }
          TextField("Additional details", text: $event.details, prompt: Text("Required"), axis: .vertical)
            .lineLimit(5...10)
          // MARK: - Predict EventType
//            .onChange(of: event.details, initial: true) { _, newValue in
//              if let eventType = data.predictEventType(from: newValue) {
//                  event.eventType = eventType
//                }
//            }
        }

        // Event Type Picker
        HStack {
          Label("Event Type", systemImage: "list.bullet")
          Picker("", selection: $event.eventType) {
            ForEach(Event.allEventType, id: \.id) { eventType in
              Text(eventType.name).tag(eventType)
            }
          }
          .pickerStyle(MenuPickerStyle())
        }
      }

      Section(header: Text("Time Details")) {
        // Segmented Control for time selection
        Picker("Event Timing", selection: $hasTime) {
          Text("With Time").tag(true)
          Text("Without Time").tag(false)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()

        if hasTime {
          DatePicker(
            "Start Time",
            selection: Binding(
              get: { event.startTime ?? Date() },
              set: { event.startTime = $0 }
            ), displayedComponents: [.date, .hourAndMinute])

          DatePicker(
            "End Time",
            selection: Binding(
              get: { event.endTime ?? Date() },
              set: { event.endTime = $0 }
            ), displayedComponents: [.date, .hourAndMinute])
        } else {
          Button("Clear Time") {
            event.startTime = nil
            event.endTime = nil
          }
        }
      }
      
      
      Section("SubEvent") {
        Button {
          event.subEvents.append(Event(title: "New SubEvent", details: "", eventType: .study, createdTime: .now))
        } label: {
          Label(event.subEvents.isEmpty ? "New SubEvent" : "Add SubEvent", systemImage: "plus")
        }
        
        ForEach(event.subEvents) { subEvent in
          Text(subEvent.title)
        }.onDelete { indexSet in
          event.subEvents.remove(atOffsets: indexSet)
        }
      }
    }
  }
}


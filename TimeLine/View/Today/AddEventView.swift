//
//  AddEventView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/22.
//

import SwiftData
import SwiftUI

// Add and Edit Event
struct AddEventView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @Bindable var event: Event

  @State private var hasTime: Bool = false

  @State private var allEventType: [EventType] = []

  var body: some View {
//    HStack {
//      Button("Cancel") {
//        dismiss()
//      }
//      Spacer()
//      Button("Save") {
//        dismiss()
//      }
//    }
    Form {
      // MARK: - Event Detail Section

      Section("Event Detail") {
        // Title row
        HStack(alignment: .top) {
          Label("Title", systemImage: "note.text")
          TextField("Enter title", text: $event.title)
            .lineLimit(3...5) // Adjust line limits as needed
        }

        // Details row
        VStack(alignment: .leading, spacing: 6) {
          HStack {
            Label("Details", systemImage: "info.circle")
            Spacer()
          }
          TextField(
            "Additional details",
            text: $event.details,
            prompt: Text("Required"),
            axis: .vertical
          )
          .lineLimit(5...10)
//           .onChange(of: event.details) { newValue in
//               if let predictedType = somePredictEventTypeFunction(from: newValue) {
//                   event.eventType = predictedType
//               }
//           }
        }

        // Event Type Picker
        HStack {
          Label("Event Type", systemImage: "list.bullet")
          Picker("Select Type", selection: $event.eventType) {
            ForEach(allEventType) { eventType in
              Text(eventType.name).tag(eventType)
            }
          }
          .pickerStyle(MenuPickerStyle())
        }
      }

      // MARK: - Time Details Section

      Section("Time Details") {
        // Switch between "With Time" and "Without Time"
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
            ),
            displayedComponents: [.date, .hourAndMinute]
          )

          DatePicker(
            "End Time",
            selection: Binding(
              get: { event.endTime ?? Date() },
              set: { event.endTime = $0 }
            ),
            displayedComponents: [.date, .hourAndMinute]
          )
        } else {
          Button("Clear Time") {
            event.startTime = nil
            event.endTime = nil
          }
        }
      }

      // MARK: - SubEvents Section

      Section("SubEvent") {
        Button {
          let newSubEvent = Event(
            title: "New SubEvent",
            details: "",
            eventType: allEventType[0],
            startTime: nil,
            endTime: nil,
            parentOfEvent: event
          )
          event.subEvents.append(newSubEvent)
        } label: {
          Label(
            event.subEvents.isEmpty ? "New SubEvent" : "Add SubEvent",
            systemImage: "plus"
          )
        }

        ForEach($event.subEvents) { $sub in
          Text(sub.title)
        }
        .onDelete { indexSet in
          event.subEvents.remove(atOffsets: indexSet)
        }
      }

      // MARK: - Priority Section (customize as needed)

      Section("Priority") {
        HStack {
          Label("Priority", systemImage: "flame")
          Spacer()
          Picker("Priority", selection: $event.importance) {
            Text("Low").tag(0)
            Text("Medium").tag(1)
            Text("High").tag(2)
          }
        }
      }
    }
    .onAppear {
      self.allEventType = fetchAllEventTypes()
      self.hasTime = event.startTime != nil || event.endTime != nil
    }
  }

  func fetchAllEventTypes() -> [EventType] {
    let descriptor = FetchDescriptor<EventType>(
      sortBy: [SortDescriptor(\.name, order: .forward)]
    )

    do {
      return try modelContext.fetch(descriptor)
    } catch {
      print("Fetch error: \(error)")
      return []
    }
  }
}

//
//  AddEventView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/22.
//

import Combine
import SwiftData
import SwiftUI
import TipKit

// Add and Edit Event
struct AddEventView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  
  @EnvironmentObject var viewModel: ViewModel
  
  @Bindable var event: Event
  
  @State private var hasTime: Bool = false
  @State private var showErrorAlert = false
  @State private var errorMessage = ""
  
  var body: some View {
    NavigationStack {
      Form {
        eventDetailsSection
        timeDetailsSection
        subEventsSection
        deleteSection
      }
      .navigationTitle(event.title.isEmpty ? "New Event" : "Edit Event")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("Save", action: saveEvent)
        }
      }
      .alert("Save Error", isPresented: $showErrorAlert) {
        Button("OK") {}
      } message: {
        Text(errorMessage)
      }
      .onAppear(perform: setupInitialState)
      .onChange(of: hasTime, handleTimeToggle)
      .onChange(of: event.title) { _, newValue in
        Task {
          if let predicateType = await viewModel.predictEventType(from: newValue) {
            await MainActor.run {
              event.eventType = predicateType
            }
          }
        }
      }
    }
  }
  
  // MARK: - View Components
  
  private var eventDetailsSection: some View {
    Section("Event Detail") {
      TextField("Title", text: $event.title, prompt: Text("Enter title"))
        .lineLimit(1)
        .listRowBackground(Color.brown.opacity(0.3))
      
      TextField("Details",
                text: $event.details,
                prompt: Text("Additional details"),
                axis: .vertical)
        .lineLimit(5 ... 10)
        .listRowBackground(Color.yellow.opacity(0.3))

      Picker("Importance", selection: $event.importance) {
        ForEach(0 ..< 3) { level in
          Text(["Low", "Medium", "High"][level]).tag(level)
        }
      }
      .listRowBackground(event.priorityColor)
      
      Picker("Event Type", selection: $event.eventType) {
        ForEach(viewModel.allEventTypes) { eventType in
          Text("\(eventType.name)")
            .foregroundColor(eventType.color)
            .tag(eventType)
        }
      }
      .listRowBackground(event.eventType.color.opacity(0.3))
      
      TipView(AllTips.EventTypePredictionTips())
    }
  }
  
  private var timeDetailsSection: some View {
    Section("Time Details") {
      Picker("Event Timing", selection: $hasTime) {
        Text("With Time").tag(true)
        Text("Without Time").tag(false)
      }
      .pickerStyle(.segmented)
      
      if hasTime {
        DatePicker("Start Time",
                   selection: Binding(
                     get: { event.startTime ?? Date() },
                     set: { event.startTime = $0 }
                   ),
                   displayedComponents: [.date, .hourAndMinute])
        
        DatePicker("End Time",
                   selection: Binding(
                     get: { event.endTime ?? Date().addingTimeInterval(3600) },
                     set: { event.endTime = $0 }
                   ),
                   in: (event.startTime ?? Date(timeIntervalSince1970: 0))...,
                   displayedComponents: [.date, .hourAndMinute])
        
        if let duration = event.duration {
          Label("Duration", systemImage: "clock")
            .badge(duration)
        }
      } else {
        Text("It's an Open Event. Soon it will display on Today View.")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
    }
  }
  
  private var subEventsSection: some View {
    Section("Sub Events") {
      Button(action: addSubEvent) {
        Label("Add Sub Event", systemImage: "plus")
      }
      
      ForEach($event.subEvents) { $subEvent in
        NavigationLink {
          AddEventView(event: subEvent)
        } label: {
          VStack(alignment: .leading) {
            Text(subEvent.title)
              .font(.headline)
            Text(subEvent.eventType.name)
              .font(.caption)
              .foregroundStyle(.secondary)
          }
        }
      }
      .onDelete(perform: deleteSubEvents)
    }
  }
  
  private var deleteSection: some View {
    Section {
      Button("Delete Event", role: .destructive) {
        viewModel.deleteEvent(event)
        dismiss()
      }
      .foregroundColor(.red)
    }
  }
  
  private func setupInitialState() {
    hasTime = event.startTime != nil || event.endTime != nil
    validateEventTypes()
  }
  
  private func validateEventTypes() {
    if viewModel.allEventTypes.isEmpty {
      errorMessage = "No event types available"
      showErrorAlert = true
    }
  }
  
  private func handleTimeToggle() {
    if !hasTime {
      event.startTime = nil
      event.endTime = nil
    } else {
      let now = Date()
      event.startTime = now
      event.endTime = now.addingTimeInterval(3600)
    }
  }
  
  private func addSubEvent() {
    let newSubEvent = Event(
      title: "New Sub Events",
      details: "",
      eventType: event.eventType,
      startTime: nil,
      endTime: nil,
      parentOfEvent: event
    )
    
    event.addSubEvent(newSubEvent)
  }
  
  private func deleteSubEvents(at offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        let subEvent = event.subEvents[index]
        modelContext.delete(subEvent)
      }
      event.subEvents.remove(atOffsets: offsets)
    }
  }
  
  private func saveEvent() {
    do {
      try modelContext.save()
      dismiss()
    } catch {
      errorMessage = "Failed to save event: \(error.localizedDescription)"
      showErrorAlert = true
    }
  }
}

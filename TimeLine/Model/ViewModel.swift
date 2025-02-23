//
//  +HomeView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/2/18.
//

import CoreML
import SwiftData
import SwiftUI

@MainActor
class ViewModel: ObservableObject {
  let container: ModelContainer
  var modelContext: ModelContext

  @Published
  var allEvents: [Event] = []

  @Published
  var allEventTypes: [EventType] = []

  private func checkAndInsertInitialData() {
    guard allEventTypes.isEmpty else { return }

    let presetTypes: [(String, Color)] = [
      ("STUDY", Color.blue),
      ("WORK", Color.green),
      ("FITNESS", Color.orange),
      ("LIFE", Color.yellow),
      ("LEISURE", Color.purple),
      ("SOCIAL", Color.red),
      ("FINANCE", Color.gray),
      ("CREATIVITY", Color.pink)
    ]

    for type in presetTypes {
      addEventType(name: type.0, color: type.1)
    }

    do {
      try modelContext.save()
    } catch {
      print("Failed to save initial event types: \(error)")
    }
  }

  init() {
    #if DEBUG
    let isMemoryOnly = true
    #else
    let isMemoryOnly = false
    #endif

    do {
      container = try ModelContainer(
        for: Event.self,
        EventType.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: isMemoryOnly)
      )
      modelContext = ModelContext(container)

      fetch()
      checkAndInsertInitialData()
      loadModel()
    } catch {
      fatalError("Failed to initialize ModelContainer: \(error)")
    }
  }

  func fetch() {
    // Fetch all events
    let eventDescriptor = FetchDescriptor<Event>(predicate: #Predicate {
      $0.parentOfEvent == nil
    })
    do {
      allEvents = try modelContext.fetch(eventDescriptor)
    } catch {
      print("Failed to fetch events: \(error)")
    }

    // Fetch all event types
    let eventTypeDescriptor = FetchDescriptor<EventType>()
    do {
      allEventTypes = try modelContext.fetch(eventTypeDescriptor)
    } catch {
      print("Failed to fetch event types: \(error)")
    }
    
    objectWillChange.send()
  }

  func addEvent(eventType: EventType? = nil) -> Event {
    withAnimation(.easeInOut(duration: 0.5)) {
      do {
        let selectedType = eventType ?? allEventTypes.first!
        let newEvent = Event(title: "", details: "", eventType: selectedType)
        allEvents.append(newEvent)
        modelContext.insert(newEvent)
        try modelContext.save()
        return newEvent
      } catch {
        print("add event error: \(error)")
        fatalError()
      }
    }
  }

  func addEventType(name: String, color: Color) {
    do {
      let newType = EventType(
        name: name.uppercased(),
        hexString: color.toHex()
      )
      allEventTypes.append(newType)
      modelContext.insert(newType)
      try modelContext.save()
    } catch {
      print("add event type error: \(error)")
    }
  }

  func deleteEvent(_ event: Event) {
    withAnimation(.easeInOut(duration: 0.5)) {
      do {
        event.parentOfEvent?.subEvents.removeAll { $0 == event }
        allEvents.removeAll { $0 == event }
        modelContext.delete(event)
        try modelContext.save()
        fetch()
      } catch {
        print("delete event error: \(error)")
      }
    }
  }

  private var model: EventClassify?

  private func loadModel() {
    Task {
      do {
        let config = MLModelConfiguration()
        self.model = try EventClassify(configuration: config)
      } catch {
        print("Model loading error: \(error)")
      }
    }
  }

  func predictEventType(from text: String) async -> EventType? {
    guard let model = model else {
      // Model not yet loaded
      return nil
    }

    do {
      print("Predicting for text: \(text)")
      let input = EventClassifyInput(text: text)
      let prediction = try await model.prediction(input: input)

      print("Raw prediction: \(prediction)")
      print("Predicted label: \(prediction.label)")

      let eventTypeName = prediction.label.uppercased()
      print("Looking for: \(eventTypeName)")
      print("Available types: \(allEventTypes.map { $0.name })")

      return allEventTypes.first { $0.name == eventTypeName }
    } catch {
      print("Prediction error: \(error)")
      return nil
    }
  }
}

extension ViewModel {
  func events(atHour date: Date) -> [Event] {
    let calendar = Calendar.current
    guard let startOfHour = calendar.date(
      from: calendar.dateComponents([.year, .month, .day, .hour], from: date)
    ),
      let endOfHour = calendar.date(byAdding: .hour, value: 1, to: startOfHour)
    else {
      return []
    }

    return allEvents
      .filter { event in
        guard let start = event.startTime else {
          return false
        }
        return start >= startOfHour && start < endOfHour
      }
  }
}

extension ViewModel {
  var nowEvents: [Event] {
    let now = Date()
    return allEvents
      .filter { event in
        guard let startTime = event.startTime, let endTime = event.endTime else {
          return false
        }
        return startTime <= now && endTime >= now && event.isCompleted == false
      }
      .filter {
        $0.isCompleted == false
      }
  }

  var openEvents: [Event] {
    allEvents
      .filter { event in
        event.endTime == nil || event.startTime == nil
      }
      .filter {
        $0.isCompleted == false
      }
  }
}

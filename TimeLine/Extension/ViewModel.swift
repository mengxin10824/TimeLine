//
//  +HomeView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/2/18.
//

import CoreML
import SwiftData
import SwiftUI

@Observable
class ViewModel: ObservableObject {
  let container: ModelContainer
  var modelContext: ModelContext

  var allEvents: [Event] = []
  var allEventTypes: [EventType] = []

  private func checkAndInsertInitialData() {
    guard allEventTypes.isEmpty else { return }

    let presetTypes = [
      EventType(name: "STUDY", hexString: Color.blue.toHex()),
      EventType(name: "WORK", hexString: Color.green.toHex()),
      EventType(name: "FITNESS", hexString: Color.orange.toHex()),
      EventType(name: "LIFE", hexString: Color.yellow.toHex()),
      EventType(name: "LEISURE", hexString: Color.purple.toHex()),
      EventType(name: "SOCIAL", hexString: Color.red.toHex()),
      EventType(name: "FINANCE", hexString: Color.gray.toHex()),
      EventType(name: "CREATIVITY", hexString: Color.pink.toHex())
    ]

    for type in presetTypes {
      modelContext.insert(type)
    }

    do {
      try modelContext.save()
    } catch {
      print("Failed to save initial event types: \(error)")
    }
  }

  init() {
    do {
      container = try ModelContainer(for: Event.self, EventType.self)
    } catch {
      fatalError("Failed to initialize ModelContainer: \(error)")
    }
    modelContext = ModelContext(container)
    
    fetch()
    
    checkAndInsertInitialData()
  }

  func fetch() {
    // Fetch all events
    let eventDescriptor = FetchDescriptor<Event>()
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
  }
}

extension ViewModel {
  func predictEventType(from text: String) -> EventType? {
    do {
      let config = MLModelConfiguration()
      let model = try EventClassify(configuration: config)
      let input = EventClassifyInput(text: text)
      let prediction = try model.prediction(input: input)

      let eventTypeName = prediction.label.uppercased()
      return allEventTypes.first { $0.name == eventTypeName }
    } catch {
      print("Error predicting event type: \(error.localizedDescription)")
      return nil
    }
  }
}

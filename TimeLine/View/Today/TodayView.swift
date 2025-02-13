//
//  TodayView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

import SwiftData
import SwiftUI

struct TodayView: View {
  @State var modifyEvent: Event?
  @Environment(\.modelContext) private var modelContext

  @Query var eventTypes: [EventType]

  var body: some View {
    ZStack(alignment: .top) {
      TodayToolBarView()
        .zIndex(2)

      ZStack(alignment: .bottom) {
        TodayScrollView()

        // Add Button
        HStack {
          Spacer()
          Button {
            addEvent()
          } label: {
            Image(systemName: "plus")
              .font(.title)
              .foregroundStyle(.white)
              .padding()
              .background(.blue)
              .clipShape(Circle())
          }
          .contextMenu {
            Section("Quick Add By Event Type") {
              ForEach(eventTypes) { eventType in
                Button("\(eventType.name)") {
                  addEvent(eventType: eventType)
                }
              }
            }
          }
        }
        .padding(20)
      }
      .sheet(item: $modifyEvent, onDismiss: {
        modifyEvent = nil
      }) { currentEvent in
        AddEventView(event: currentEvent)
      }
    }
  }

  func addEvent(eventType: EventType? = nil) {
    let currentEventTypes = eventType ?? eventTypes.first!
    let newEvent = Event(title: "", details: "", eventType: currentEventTypes)
    modelContext.insert(newEvent)
    modifyEvent = newEvent
    try? modelContext.save()
  }
}

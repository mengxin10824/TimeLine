//
//  TodayView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

import SwiftData
import SwiftUI

struct TimeLineView: View {
  @State var modifyEvent: Event?
  @Environment(\.modelContext) var modelContext
  @EnvironmentObject var viewModel: ViewModel

  var body: some View {
      ZStack(alignment: .bottom) {
        TodayScrollView()

        // Add Button
        HStack {
          Spacer()
          Button {
            modifyEvent = viewModel.addEvent()
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
              ForEach(viewModel.allEventTypes) { eventType in
                Button("\(eventType.name)") {
                  modifyEvent = viewModel.addEvent(eventType: eventType)
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

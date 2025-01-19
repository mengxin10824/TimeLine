//
//  TimeLineMainView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

import SwiftUI

struct TimeLineMainView: View {
  @State var events: [Event] = Event.demoEvents

  var body: some View {
    ScrollView([.horizontal, .vertical]) {
      LazyVStack(alignment: .leading, spacing: 50, pinnedViews: []) {
        ForEach(Array(events.enumerated()), id: \.offset) { index, event in
          HStack {
            Spacer()

            EventBlockView(event: event)
          }
        }
      }
      .background(alignment: .leading) {
        RoundedRectangle(cornerRadius: 20)
          .fill()
          .frame(width: 25)
      }
    }.scrollIndicators(.hidden)
      .padding()
      .ignoresSafeArea()

  }

  @ViewBuilder
  func EventBlockView(event: Event) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20).fill(.white).shadow(radius: 5)

      VStack {
        Text(event.title)
          .font(.title2)
          .bold()
        Text(event.details)
          .lineLimit(2)
        Spacer()
      }

    }
    .frame(minWidth: 300, minHeight: 200)

    .contextMenu(
      menuItems: {
        Label("1", systemImage: "circle")
      },
      preview: {
        EventBlockPreview(event: event)
      })
  }

  @ViewBuilder
  func EventBlockPreview(event: Event) -> some View {
    Text("11111")
  }
}

#Preview{
  TimeLineMainView(events: Event.demoEvents)
}

//
//  TimeLineMainEventBlockView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/25.
//

import SwiftUI

struct TimeLineMainEventBlockView: View {
  @State var event: Event
  var body: some View {
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
}

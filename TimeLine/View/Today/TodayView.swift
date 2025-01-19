//
//  TodayView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

import SwiftUI

struct TodayView: View {
  @State var isAdd = false
  var body: some View {
    ZStack(alignment: .top) {
      ToolBarView().padding(.horizontal)
        .frame(height: 80)
        .background(
          LinearGradient(
            stops: [
              Gradient.Stop(color: Color(UIColor.systemBackground), location: 0.7),
              Gradient.Stop(color: Color(UIColor.systemBackground).opacity(0.1), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
          )
        )
        .background(.ultraThinMaterial)

      ZStack(alignment: .bottom) {
        // TimeLine Main View
        TimeLineMainView().padding(.horizontal)

        // Add Button
        HStack {
          Spacer()
          Button {
            isAdd.toggle()
          } label: {
            Image(systemName: "plus")
              .font(.title)
              .foregroundStyle(.white)
              .padding()
              .background(.blue)
              .clipShape(Circle())
          }
        }.padding(20)
      }.zIndex(-1)
        .sheet(isPresented: $isAdd) {
          var event = Event(
            title: "Join to part", details: "aidbaibdabdajbdasjdbjakdjbkasbdk", eventType: .finance,
            createdTime: .now, startTime: nil, endTime: nil, durationTime: 20)
          AddEventView(event: event)
        }

    }
  }
}

struct CapsuleSearchButton: View {
  var body: some View {
    Button(action: {
      print("Search tapped")
    }) {
      HStack {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.secondary)
        Text("Search All Event")
          .foregroundColor(.secondary)
      }
      .padding(.horizontal, 15)
      .padding(.vertical, 8)
      .background(Capsule().fill(Color(.systemGray6)))
    }
  }
}

struct ToolBarView: View {
  @State var isTap = false
  var body: some View {
    HStack {
      CapsuleSearchButton()
      Spacer()
      Button {

      } label: {
        Image(systemName: "line.3.horizontal.decrease.circle")
          .font(.title2)
      }
      .contextMenu {
        Section("Quick Filter") {
          Button("Filter By Type", systemImage: "circle", action: {})
          Button("Filter By Time", systemImage: "circle", action: {})
          Button("Filter By Priority", systemImage: "circle", action: {})
        }
      }
      // tap animation
    }
  }
}

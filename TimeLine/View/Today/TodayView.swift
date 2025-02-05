//
//  TodayView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

import SwiftUI

struct TodayView: View {
  @State var isAdd = false
  @Environment(\.modelContext) private var modelContext

  var body: some View {
    // MARK: - 半透明亚克力背景 + 背景模糊 + 杂色

    ZStack(alignment: .top) {
      ToolBarView()
        .padding(.horizontal)
        .frame(height: 80)
//        .background(.ultraThinMaterial)
        .noiseBackground(opacity: 0.2)
        .background()
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

      ZStack(alignment: .bottom) {
        TimeLineMainView()
          .padding(.horizontal)

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
        }
        .padding(20)
      }
      .sheet(isPresented: $isAdd) {
        AddEventView(modelContext: modelContext)
      }
      .zIndex(-1)
        
    }
  }
}

struct CapsuleSearchButton: View {
  var body: some View {
    Button(action: {
      // MARK: - ADD Search Action
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
      Button {} label: {
        Image(systemName: "line.3.horizontal.decrease.circle")
          .font(.title2)
      }
      .contextMenu {
        Section("Quick Filter") {
          Button("Filter By Type", systemImage: "list.bullet.indent", action: {})
          Button("Filter By Time", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90", action: {})
          Button("Filter By Priority", systemImage: "flame", action: {})
        }
      }

      // MARK: - TAP animation 快捷筛选
    }
  }
}

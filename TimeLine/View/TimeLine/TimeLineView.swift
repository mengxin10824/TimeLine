//
//  TodayView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//
import SwiftUI

struct TimeLineView: View {
  @State var modifyEvent: Event?
  @Environment(\.modelContext) var modelContext
  @EnvironmentObject var viewModel: ViewModel

  @State var isBackToNow: Bool = false
  @State var filterType: FilterType = .none
  var body: some View {
    ZStack(alignment: .bottom) {
      TodayScrollView(isBackToNow: $isBackToNow)
        .environment(\.filterType, filterType)

      HStack {
        Spacer()
        Button {
          isBackToNow = true
          if filterType != .none {
            filterType = .none
          } else {
            filterType = .byType
          }
        } label: {
          Image(systemName: "line.3.horizontal.decrease")
            .font(.title)
            .frame(width: 30, height: 30)
            .foregroundStyle(.white)
            .padding()
            .background(.green)
            .clipShape(Circle())
        }
        .contextMenu {
          Button("Back to Now", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90", action: {
            isBackToNow = true
          })

          Section("Quick Filter") {
            Button("Filter By Type", systemImage: "list.bullet.indent", action: {
              filterType = .byType
            })
            Button("Filter By Time", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90", action: {
              filterType = .byTime
            })
            Button("Filter By Priority", systemImage: "flame", action: {
              filterType = .byPriority
            })
          }
        }
        .popoverTip(AllTips.FilterTips())
      }.padding(20)
    }
    .sheet(item: $modifyEvent, onDismiss: {
      modifyEvent = nil
      viewModel.fetch()
    }) { currentEvent in
      AddEventView(event: currentEvent)
    }
  }
}

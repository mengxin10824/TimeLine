//
//  TodayToolBarView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/2/7.
//

import SwiftUI

struct TodayToolBarView: View {
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
        Button("Back to Now", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90") {
          
        }
        Button("Quick Add", systemImage: "plus") {
          
        }
        
        Section("Quick Filter") {
          Button("Filter By Type", systemImage: "list.bullet.indent", action: {
            
          })
          Button("Filter By Time", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90", action: {
            
          })
          Button("Filter By Priority", systemImage: "flame", action: {
            
          })
        }
      }

      // MARK: - TAP animation 快捷筛选
    }
    .padding()
    .padding(.bottom, 10)
    .background()
//    .mask {
//      LinearGradient(colors: [.clear, .clear.opacity(0)], startPoint: .init(x: 0, y: 0.3), endPoint: .init(x: 0, y: 1))
//    }
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
      .background(Capsule().fill(.gray.opacity(0.1)))
    }
  }
}

#Preview {
    TodayToolBarView()
    .border(.black, width: 1)
}

//
//  TimeLineMainBarView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/25.
//

import SwiftUI

struct TimeLineMainBarView: View {
  @State var currentTime: Date
  @Binding var events: [Event]
  let index: Int
  
    var body: some View {
      ZStack(alignment: .bottomTrailing) {
          BarBackgroundView(index: index)
          Text(currentTime.description)
              .font(.caption)
              .fixedSize()
              .position(x: 50)
      }
    }

  // MARK: - The shape of the bar
  func BarBackgroundView(index: Int) -> some Shape {
      if index == 0 {
          return AnyShape(
              UnevenRoundedRectangle(
                  topLeadingRadius: .infinity, bottomLeadingRadius: 0, bottomTrailingRadius: 0,
                  topTrailingRadius: .infinity, style: .continuous))
      } else if index == events.count - 1 {
          return AnyShape(
              UnevenRoundedRectangle(
                  topLeadingRadius: 0, bottomLeadingRadius: .infinity, bottomTrailingRadius: .infinity,
                  topTrailingRadius: 0, style: .continuous))
      } else {
          return AnyShape(Rectangle())
      }
  }
}

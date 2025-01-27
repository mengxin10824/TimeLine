//
//  TimeLineMainBarView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/25.
//

import SwiftUI

struct TimeLineMainBarView: View {
  @State var currentTime: Date

  private var isFirst: Bool
  private var isLast: Bool
  private var isNow: Bool

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      BarBackgroundView()
        .overlay(alignment: .topLeading) {
          Text(currentTime.toRelateiveDateString())
            .foregroundStyle(.gray)
            .font(.caption)
            .fixedSize()
            .position(x: 65)
        }
    }
  }

  func BarBackgroundView() -> some Shape {
    if isFirst {
      return AnyShape(
        UnevenRoundedRectangle(
          topLeadingRadius: .infinity, bottomLeadingRadius: 0, bottomTrailingRadius: 0,
          topTrailingRadius: .infinity, style: .continuous))
    } else if isLast {
      return AnyShape(
        UnevenRoundedRectangle(
          topLeadingRadius: 0, bottomLeadingRadius: .infinity, bottomTrailingRadius: .infinity,
          topTrailingRadius: 0, style: .continuous))
    } else {
      return AnyShape(Rectangle())
    }
  }
  
  init(currentTime: Date, isFirst: Bool = false, isLast: Bool = false, isNow: Bool = false) {
    self.currentTime = currentTime
    self.isFirst = isFirst
    self.isLast = isLast
    self.isNow = isNow
  }
}

//
//  TimeLineMainBarView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/25.
//

import SwiftUI

struct TimeLineMainBarView: View {
  @State var hour: Date

  var isPast: Bool = false
  var isNow: Bool = false

  var body: some View {
    HStack(spacing: 0) {
      BarBackgroundView()
        .frame(width: 20)

      Text(hour.toRelativeDateString())
        .foregroundStyle(.gray)
        .font(.system(size: 10, weight: .bold))
        .fixedSize()
        .multilineTextAlignment(.leading)
        .offset(x: 10)
        .frame(width: 0, alignment: .leading)
    }
  }

  func BarBackgroundView() -> some View {
    let calendar = Calendar.current
    let hourComponents = calendar.dateComponents([.hour], from: hour)
    let hourValue = hourComponents.hour ?? 0

    if hourValue == 0 {
      return AnyView(
        UnevenRoundedRectangle(
          topLeadingRadius: .infinity,
          bottomLeadingRadius: 0,
          bottomTrailingRadius: 0,
          topTrailingRadius: .infinity,
          style: .continuous
        ).padding(.top, 20)
      )
    } else if hourValue == 23 {
      return AnyView(
        UnevenRoundedRectangle(
          topLeadingRadius: 0,
          bottomLeadingRadius: .infinity,
          bottomTrailingRadius: .infinity,
          topTrailingRadius: 0,
          style: .continuous
        )
      )
    } else {
      return AnyView(Rectangle())
    }
  }
}

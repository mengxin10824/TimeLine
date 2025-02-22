//
//  TimeLineMainBarView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/25.
//

import SwiftUI

struct TimeLineMainBarView: View {
  let hour: Date
  let hourValue: Int

  init(hour: Date) {
    self.hour = hour
    self.hourValue = Calendar.current.component(.hour, from: hour)
  }

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      ZStack {
        AnyShape(barShape())
          .fill(AnyShapeStyle(fillStyle()))
      }
      .frame(width: 20)

      let dateString = hour.toRelativeDateString()
      
      Text(dateString)
        .foregroundStyle(.gray)
        .font(
          dateString == "At Now" ?
            .system(size: 16, weight: .black) :
            .system(size: 10, weight: .bold)
        )
        .fixedSize()
        .multilineTextAlignment(.leading)
        .offset(x: 5)
        .frame(width: 0, alignment: .leading)
    }
    .padding(.top, hourValue == 0 ? 50: 0)
  }

  private func barShape() -> any Shape {
    if hourValue == 0 {
      return UnevenRoundedRectangle(
        topLeadingRadius: .infinity,
        topTrailingRadius: .infinity
      )
    } else if hourValue == 23 {
      return UnevenRoundedRectangle(
        bottomLeadingRadius: .infinity,
        bottomTrailingRadius: .infinity
      )
    } else {
      return Rectangle()
    }
  }

  private func fillStyle() -> any ShapeStyle {
    let currentDate = Date()
    let currentHour = Calendar.current.component(.hour, from: currentDate)
    let currentDay = Calendar.current.component(.day, from: currentDate)
    let hourDay = Calendar.current.component(.day, from: hour)

    if currentDay == hourDay && hourValue == currentHour {
      let currentMinute = Calendar.current.component(.minute, from: currentDate)
      let fraction = Double(currentMinute) / 60.0

      return LinearGradient(
        gradient: Gradient(stops: [
          Gradient.Stop(color: .black, location: 0),
          Gradient.Stop(color: .black, location: fraction - 0.1),
          Gradient.Stop(color: .green.opacity(0.6), location: fraction),
          Gradient.Stop(color: .gray, location: 1)
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
    } else if currentDay > hourDay || (currentDay == hourDay && hourValue < currentHour) {
      return Color.black
    } else {
      return Color.gray
    }
  }
}


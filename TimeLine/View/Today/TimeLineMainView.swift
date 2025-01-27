//
//  TimeLineMainView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

import SwiftUI

struct TimeLineMainView: View {
  @State var config = TimeLineConfiguration()
  @State var data: TimeLineData = TimeLineData()

  // MARK: - The Main View

  var body: some View {
    ScrollView([.vertical]) {
      ScrollViewReader { _ in
        LazyVStack(alignment: .leading, spacing: 0) {
          ForEach(config.cachedHours, id: \.self) { hour in
            HStack(alignment: .top, spacing: 30) {
              TimeLineMainBarView(currentTime: hour)
                .frame(width: 25, height: config.hourHeight)

              VStack {
                ForEach(data.getEventsByHour(for: hour), id: \.id) { event in
                  TimeLineMainEventBlockView(event: event)
                    .frame(width: 170, height: config.calcEventHeight(event: event))
                    .offset(y: config.calcEventOffsetY(event: event))
                }
              }.frame(maxWidth: .infinity)
            }
          }
        }
      }
    }.scrollIndicators(.hidden).ignoresSafeArea()
  }
}


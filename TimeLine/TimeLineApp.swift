//
//  TimeLineApp.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/19.
//

import SwiftData
import SwiftUI
import TipKit

@main
struct TimeLineApp: App {
  @ObservedObject var viewModel: ViewModel = .init()
  var body: some Scene {
    WindowGroup {
      HomeView()
        .environmentObject(viewModel)
        .modelContainer(viewModel.container)
        .task {
          try? Tips.configure([
            .displayFrequency(.immediate),
            .datastoreLocation(.applicationDefault)
          ])
        }
    }
  }
}

#Preview(body: {
  let viewModel = ViewModel()
  HomeView()
    .environmentObject(viewModel)
    .modelContainer(viewModel.container)
    .task {
      try? Tips.resetDatastore()

      try? Tips.configure([
        .displayFrequency(.immediate),
        .datastoreLocation(.applicationDefault)
      ])
    }
})

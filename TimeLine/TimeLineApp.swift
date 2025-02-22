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
  @StateObject var viewModel: ViewModel = ViewModel()
  var body: some Scene {
    WindowGroup {
      HomeView()
        .environmentObject(viewModel)
        .modelContainer(viewModel.container)
    }
  }
}


struct TipDemo: Tip {
  var title: Text
}

#Preview(body: {
  let viewModel = ViewModel()
  HomeView()
    .environmentObject(viewModel)
    .modelContainer(viewModel.container)
})

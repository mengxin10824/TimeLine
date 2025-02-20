//
//  HomeView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/19.
//

import SwiftData
import SwiftUI

struct HomeView: View {
  @EnvironmentObject var viewModel: ViewModel
  
  @State private var selectedTab: Int = 0
  @State private var IncompleteEventCount: Int?
  
  var body: some View {
    TabView(selection: $selectedTab) {
      Tab(value: 0) {
        NavigationStack { TodayView() }
      } label: {
        Label("Today", systemImage: "text.rectangle.page")
      }.badge(IncompleteEventCount ?? 0)
            
      Tab(value: 1) {
        NavigationStack {
          TimeLineView()
        }
      } label: {
        Label("TimeLine", systemImage: "timelapse")
      }
              
      Tab(value: 1) {
        ProfileView()
      } label: {
        Label("Profile", systemImage: "person.crop.circle")
      }
    }
    .onAppear {
      self.IncompleteEventCount = viewModel.fetchLateEvent()
    }
  }
}


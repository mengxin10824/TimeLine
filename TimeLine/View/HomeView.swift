//
//  HomeView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/19.
//

import SwiftUI

struct HomeView: View {
  @State var inCompletedTask: Int? = 0
  @Environment(\.modelContext) private var modelContext
  @State private var selectedTab: Int = 0
  
      
      var body: some View {
          TabView(selection: $selectedTab) {
              Tab(value: 0) {
                  NavigationStack { TodayView() }
              } label: {
                  Label("Today", systemImage: "timelapse")
              }
              
              Tab(value: 1) {
                  ProfileView()
              } label: {
                  Label("Profile", systemImage: "person.crop.circle")
              }
          }
      }
}

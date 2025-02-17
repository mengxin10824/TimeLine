//
//  HomeView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/19.
//

import SwiftData
import SwiftUI

struct HomeView: View {
  @State private var selectedTab: Int = 0
  
  @Environment(\.modelContext) private var modelContext
  @State private var IncompleteEventCount: Int?
      
  var body: some View {
    TabView(selection: $selectedTab) {
      Tab(value: 0) {
        NavigationStack { TodayView() }
      } label: {
        Label("Today", systemImage: "text.rectangle.page")
      }.badge(IncompleteEventCount ?? 0)
            
      Tab(value: 1) {
        NavigationStack { TimeLineView() }
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
      let now = Date()
      let predicate = #Predicate<Event> {
        $0.endTime != nil && $0.endTime! < now
      }
              
      let fetchDescriptor = FetchDescriptor<Event>(predicate: predicate)
      IncompleteEventCount = try? modelContext.fetchCount(fetchDescriptor)
    }
  }
}

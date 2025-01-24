//
//  HomeView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/19.
//

import SwiftUI

struct HomeView: View {
    @State var inCompletedTask: Int? = 0
    
    var body: some View {
        TabView {
            Tab {
              NavigationStack { TodayView() }
            } label: {
                Label("Today", systemImage: "timelapse")
            }.badge(inCompletedTask ?? 0)
            
            Tab {
                
            } label: {
                Label("Archive", systemImage: "archivebox")
            }
            
            Tab {
                ProfileView()
            } label: {
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
    }
}

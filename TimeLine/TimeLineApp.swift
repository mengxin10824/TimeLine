//
//  TimeLineApp.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/19.
//

import SwiftUI
import SwiftData

@main
struct TimeLineApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: Event.self)
    }
}


#Preview {
    HomeView()
}

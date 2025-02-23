//
//  ProfileView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

import SwiftData
import SwiftUI

struct ProfileView: View {
  @EnvironmentObject var viewModel: ViewModel
  
  @State var tintColor: Color = .green
  @State var secondaryTintColor: Color = .blue
  
  @State var isPresented = false
  
  @State var allTasksCount: Int?
  @State var completedTasksCount: Int?
  @State var incompletedTasksCount: Int?
  
  @State var data: [[Int]] = []
  var body: some View {
    NavigationStack {
      List {
        Section("ANALYSE") {
          HeatMapView(data: data, tintColor: tintColor)
            .padding()
            .contextMenu {
              Button("Export to Photo", systemImage: "photo") {
                isPresented = true
              }
              Text("Based on the data of the last 30 days")
            }
            .popoverTip(AllTips.HeatmapTips())

          
          Label {
            Text("All Tasks")
          } icon: {
            Image(systemName: "bookmark.square.fill")
          }
          .badge(allTasksCount ?? 0)
          
          Label {
            Text("Completed Tasks")
          } icon: {
            Image(systemName: "tag.square.fill")
          }
          .badge(completedTasksCount ?? 0)
          
          Label {
            Text("Incompleted Task")
          } icon: {
            Image(systemName: "flag.square.fill")
          }
          .badge(incompletedTasksCount ?? 0)
        }
        
        Section("SETTING") {
          ColorPicker("Tint Color", selection: $tintColor)
            .onChange(of: tintColor) { setUserSetting(value: tintColor.toHex(), forKey: "tintColor") }
          
          ColorPicker("Secondary Tint Color", selection: $secondaryTintColor)
            .onChange(of: secondaryTintColor) { setUserSetting(value: secondaryTintColor.toHex(), forKey: "secondaryTintColor") }
        }
        
        Section("IMPORT & EXPORT") {
          Button("Export To Photo", systemImage: "photo") {
            isPresented = true
          }
        }
      }
    }
    .onAppear {
      loadUserSetting()
      loadUserData()
    }
    .tint(secondaryTintColor)
    .sheet(isPresented: $isPresented) {
      ExportToPhoto(data: self.data, tintColor: tintColor, secondaryTintColor: secondaryTintColor)
        .presentationDetents([.medium])
    }
  }
  
  func setUserSetting(value: Any, forKey key: String) {
    UserDefaults.standard.set(value, forKey: key)
  }
  
  func loadUserSetting() {
    if let _tintColor = UserDefaults.standard.string(forKey: "tintColor") {
      tintColor = Color(hex: _tintColor)
    }
    if let _secondaryTintColor = UserDefaults.standard.string(forKey: "secondaryTintColor") {
      secondaryTintColor = Color(hex: _secondaryTintColor)
    }
  }
  
  func loadUserData() {
    let calendar = Calendar.current
    let now = Date()
    guard let startDate = calendar.date(byAdding: .day, value: -140, to: now) else { return }
    
    data = Array(repeating: Array(repeating: 0, count: 20), count: 7)
    for event in viewModel.allEvents {
      let eventDate = event.createdTime
                
      guard eventDate >= startDate && eventDate <= now else { continue }
              
      let weekDiff = calendar.dateComponents([.day], from: startDate, to: eventDate).day! / 7
                
      let weekday = (calendar.component(.weekday, from: eventDate) + 5) % 7
                
      if (0 ... 19).contains(weekDiff) && (0 ... 6).contains(weekday) {
        data[weekday][weekDiff] += 1
      }
    }
    
    allTasksCount = viewModel.allEvents.count
    completedTasksCount = viewModel.allEvents.count { $0.isCompleted }
    incompletedTasksCount = allTasksCount ?? 0  - (completedTasksCount ?? 0)
  }
}

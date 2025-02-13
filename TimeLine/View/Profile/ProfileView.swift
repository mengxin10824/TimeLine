//
//  ProfileView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

import SwiftUI

struct ProfileView: View {
  @State var tintColor: Color = .green
  @State var secondaryTintColor: Color = .blue
  
  @State var isPresented = false
  
  let data: [[Double]] = {
      var data = [[Double]]()
      for _ in 0..<7 {
          var row = [Double]()
          for _ in 0..<30 {
              row.append(Double.random(in: 0...1))
          }
          data.append(row)
      }
      return data
  }()
    
  var body: some View {
    NavigationStack {
      List {
        Section("NOW") {
          
        }
        
        
        Section("ANALYSE") {
          HeatMapView(data: data, tintColor: tintColor)
            .padding()
            .contextMenu {
              Button("Export to Photo", systemImage: "photo") {
                isPresented = true
              }
              Text("Based on the data of the last 30 days")
            }
          
          Label {
            Text("All Tasks")
          } icon: {
            Image(systemName: "bookmark.square.fill")
          }
          .badge(10)
          
          Label {
            Text("Completed Tasks")
          } icon: {
            Image(systemName: "tag.square.fill")
          }
          .badge(10)
          
          Label {
            Text("Incompleted Task")
          } icon: {
            Image(systemName: "flag.square.fill")
          }
          .badge(10)
        }
        
        Section("SETTING"){
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
      .scrollContentBackground(.hidden)
      .background(ProfileBackgroundView())
    }
    .onAppear { loadUserSetting() }
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
  
}


#Preview {
  var data: [[Double]] {
    var data = [[Double]]()
    for _ in 0..<7 {
        var row = [Double]()
        for _ in 0..<30 {
            row.append(Double.random(in: 0...1))
        }
        data.append(row)
    }
    return data
  }
  
  ProfileView(isPresented: true)
}

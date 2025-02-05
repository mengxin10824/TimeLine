//
//  ProfileView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

import SwiftUI

struct ProfileView: View {
    @State var isOn = false
    
    var body: some View {
        NavigationStack {
            List {
              // MARK: - 转移到 ArchiveView
#if os(iOS)
                Section("ANALYSE") {
                    HeatMapView()
                }
#endif
                Section("SETTING"){
                    Toggle("TimeLine", isOn: $isOn)
                }
                Section("IMPORT & EXPORT") {
                  // MARK: - 导入导出 导出png
                }
                Section("TEMPLATE") {
                  // MARK: - 模版？
                }
            }
        }
    }
}

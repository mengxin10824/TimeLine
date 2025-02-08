//
//  TodayView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

import SwiftUI

struct TodayView: View {
  @State var isAdd = false
  @Environment(\.modelContext) private var modelContext

  var body: some View {
    ZStack(alignment: .top) {
      TodayBackgroundView()
      
      TodayToolBarView()

      ZStack(alignment: .bottom) {
        TodayScrollView()

        // Add Button
        HStack {
          Spacer()
          Button {
            isAdd.toggle()
          } label: {
            Image(systemName: "plus")
              .font(.title)
              .foregroundStyle(.white)
              .padding()
              .background(.blue)
              .clipShape(Circle())
          }
        }
        .padding(20)
      }
      .sheet(isPresented: $isAdd) {
        AddEventView(modelContext: modelContext)
      }
      .zIndex(1)
        
    }
  }
}



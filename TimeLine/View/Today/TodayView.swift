//
//  TodayView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/2/16.
//

import SwiftUI

struct TodayView: View {
  @EnvironmentObject var viewModel: ViewModel
  
  @State private var seletedEvent: Event?
  
  var body: some View {
    ZStack {
      BackgroundView().ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: 30) {
        HStack(alignment: .bottom) {
          Text("Today")
            .font(.system(size: 48, weight: .black))
          
          Spacer()
          
          Text(Date().toTodayString())
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(.secondary)
        }
        
        VStack(alignment: .leading, spacing: 15) {
          let nowEvents = Array(viewModel.nowEvents.prefix(3))
          HStack {
            Text("On Going")
              .foregroundStyle(.secondary)
              .font(.system(size: 36, weight: .black))
            Spacer()
          }
          
          todayEvents(events: nowEvents)
        }
        
        VStack(alignment: .leading, spacing: 15) {
          let openEvents = Array(viewModel.openEvents.prefix(3))
          HStack {
            Text("Open Event")
              .foregroundStyle(.secondary)
              .font(.system(size: 36, weight: .black))
            Spacer()
          }
          todayEvents(events: openEvents)
        }

      }.padding()
    }
    .sheet(item: $seletedEvent) {
      seletedEvent = nil
    } content: { currentEvent in
      AddEventView(event: currentEvent)
    }
  }
    
  @ViewBuilder
  func todayEvents(events: [Event]) -> some View {
    if events.isEmpty {
      RoundedRectangle(cornerRadius: 25)
        .fill(.gray.opacity(0.1))
        .overlay(
          Text("No current Event")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
        )
        .frame(height: 200)
    }
    
    VStack(spacing: 5) {
      ForEach(events) { event in
        VStack(alignment: .leading, spacing: 5) {
          HStack {
            Text(event.title)
              .font(.title2)
              .fontWeight(.bold)
              
            Spacer()
              
            Text(event.importance == 0 ? "LOW" :
              event.importance == 1 ? "MEDIUM" : "HIGH")
              .font(.subheadline)
              .fontWeight(.semibold)
              .padding(.horizontal, 12)
              .padding(.vertical, 4)
              .background(event.eventType.color.opacity(0.2))
              .clipShape(RoundedRectangle(cornerRadius: 8))
          }
            
          HStack(spacing: 8) {
            if let startTime = event.startTime,
               let endTime = event.endTime
            {
              Text("\(startTime.formatted(date: .omitted, time: .shortened)) - \(endTime.formatted(date: .omitted, time: .shortened))")
            }
            Text(event.eventType.name)
          }
          .font(.headline)
          .foregroundStyle(.secondary)
        }
        .padding()
        .background(event.eventType.color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .onTapGesture {
          self.seletedEvent = event
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: 25))
    }
  }
}


//
//  TodayView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/2/16.
//

import SwiftUI

struct TodayView: View {
  @EnvironmentObject var viewModel: ViewModel
  
  @State var modifyEvent: Event?
  
  var body: some View {
    ZStack {
      BackgroundView().ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: 15) {
        HStack(alignment: .bottom) {
          Text("Today")
            .font(.system(size: 48, weight: .black))
          
          Spacer()
          
          Text(Date().toTodayString())
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(.secondary)
        }
        
        VStack(alignment: .leading, spacing: 10) {
          HStack(alignment: .bottom) {
            Text("On Going")
              .foregroundStyle(.secondary)
              .font(.system(size: 36, weight: .black))
            Text(viewModel.nowEvents.count.description)
              .font(.system(size: 12, weight: .bold))
              .foregroundStyle(.secondary)
            Spacer()
          }
          
          todayEvents(events: viewModel.nowEvents)
        }
        .frame(idealHeight: 200)
        
        VStack(alignment: .leading, spacing: 10) {
          HStack(alignment: .bottom) {
            Text("Open Event")
              .foregroundStyle(.secondary)
              .font(.system(size: 36, weight: .black))
            Text(viewModel.openEvents.count.description)
              .font(.system(size: 12, weight: .bold))
              .foregroundStyle(.secondary)
            Spacer()
          }
          todayEvents(events: viewModel.openEvents)
        }
        .frame(idealHeight: 200)

        Spacer(minLength: 0)
        
        Button {
          modifyEvent = viewModel.addEvent()
        } label: {
          Image(systemName: "plus")
            .font(.title)
            .frame(width: 30, height: 30)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(Circle())
        }
        .contextMenu {
          Section("Quick Add By Event Type") {
            ForEach(viewModel.allEventTypes) { eventType in
              Button("\(eventType.name)") {
                modifyEvent = viewModel.addEvent(eventType: eventType)
              }
            }
          }
        }
        .popoverTip(AllTips.AddTips(), arrowEdge: .bottom)
        .frame(maxWidth: .infinity, alignment: .bottomTrailing)
      }
      .padding()
    }
    .sheet(item: $modifyEvent) {
      modifyEvent = nil
      viewModel.fetch()
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
    }
    
    VStack(spacing: 5) {
      ForEach(Array(events.prefix(2))) { event in
        VStack(alignment: .leading, spacing: 5) {
          HStack {
            Text(event.title)
              .font(.title2)
              .fontWeight(.bold)
              .strikethrough(event.isCompleted)
              
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
          self.modifyEvent = event
        }
        .contextMenu(
          menuItems: {
            Section("Actions") {
              Button("Edit", systemImage: "pencil") {
                modifyEvent = event
              }
              Button(event.isCompleted ? "Incomplete" : "Complete", systemImage: event.isCompleted ? "arrow.uturn.left" : "checkmark") {
                event.isCompleted.toggle()
              }
              Button("Delete", systemImage: "trash", role: .destructive) {
                viewModel.deleteEvent(event)
              }
            }
          },
          preview: {
            EventBlockView(event: event, isPreview: true)
          }
        )
      }
      .clipShape(RoundedRectangle(cornerRadius: 25))
      .transition(.move(edge: .leading).combined(with: .opacity))
    }
    
    if events.count > 2 {
      RoundedRectangle(cornerRadius: 25)
        .fill(.gray.opacity(0.1))
        .overlay(
          Text("More \(events.count - 2) events")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
        )
        .padding(.top, 10)
    }
  }
}


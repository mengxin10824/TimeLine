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
      let container: ModelContainer

      init() {
          do {
            container = try ModelContainer(for: Event.self, EventType.self)
              checkAndInsertInitialData()
          } catch {
              fatalError("Failed to initialize ModelContainer: \(error)")
          }
      }
      
      var body: some Scene {
          WindowGroup {
              HomeView()
          }
          .modelContainer(container)
      }
      
      private func checkAndInsertInitialData() {
          let context = container.mainContext
          
          let descriptor = FetchDescriptor<EventType>()
          let existingCount = (try? context.fetchCount(descriptor)) ?? 0
          
          guard existingCount == 0 else { return }
          
          let presetTypes = [
              EventType(name: "STUDY", hexString: Color.blue.toHex()),
              EventType(name: "WORK", hexString: Color.green.toHex()),
              EventType(name: "FITNESS", hexString: Color.orange.toHex()),
              EventType(name: "LIFE", hexString: Color.yellow.toHex()),
              EventType(name: "LEISURE", hexString: Color.purple.toHex()),
              EventType(name: "SOCIAL", hexString: Color.red.toHex()),
              EventType(name: "FINANCE", hexString: Color.gray.toHex()),
              EventType(name: "CREATIVITY", hexString: Color.pink.toHex())
          ]
          
          presetTypes.forEach { context.insert($0) }
          
          try? context.save()
      }
}


#Preview(body: {
  let config = ModelConfiguration(
      isStoredInMemoryOnly: true,
      allowsSave: true
  )
  
  // 创建包含所有模型的容器
  let container = try! ModelContainer(
      for: Event.self,
      EventType.self,
      configurations: config
  )
  
  // 插入预览需要的初始数据
  let context = container.mainContext
  let previewTypes = [
      EventType(name: "STUDY", hexString: Color.blue.toHex()),
      EventType(name: "WORK", hexString: Color.green.toHex())
  ]
  let previewEvent = [
    Event(title: "Now", details: "21313618", eventType: previewTypes[0], startTime: .now, endTime: Calendar.current.date(byAdding: .hour, value: 2, to: .now))
  ]
  previewTypes.forEach { context.insert($0) }
  previewEvent.forEach { context.insert($0) }

  
  return HomeView()
      .modelContainer(container)
      // 可选：注入预览用的环境值
      .environment(\.calendar, Calendar(identifier: .gregorian))
})

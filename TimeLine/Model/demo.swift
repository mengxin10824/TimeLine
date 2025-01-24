////
////  demo.swift
////  TimeLine
////
////  Created by mengxin10824 on 2025/1/24.
////
//
//import SwiftUI
//
//// MARK: - 时间轴视图示例
//
//struct TimeLineView: View {
//    @State var events: [Event]
//  
//    // Congigure:
//    let calendar = Calendar.current
//    let hourHeight: CGFloat = 50
//    
//    // 配置：向前后加载的小时数，用以模拟“无限滚动”
//    let hoursBeforeNow: Int = 24 * 3    // 向过去 3 天
//    let hoursAfterNow: Int = 24 * 3     // 向未来 3 天
//    
//    // 计算“时间轴的起点”和“时间轴的终点”
//    private var timelineStart: Date {
//        Calendar.current.date(byAdding: .hour, value: -hoursBeforeNow, to: Date()) ?? Date()
//    }
//    private var timelineEnd: Date {
//        Calendar.current.date(byAdding: .hour, value: hoursAfterNow, to: Date()) ?? Date()
//    }
//    
//    private var timelineHours: [Date] {
//        var result: [Date] = []
//        
//        // 从 timelineStart 到 timelineEnd 每个整点
//        let calendar = Calendar.current
//        
//        var current = timelineStart
//        while current <= timelineEnd {
//            result.append(current)
//            // 往后加 1 小时
//            guard let next = calendar.date(byAdding: .hour, value: 1, to: current) else {
//                break
//            }
//            current = next
//        }
//        return result
//    }
//    
//    var body: some View {
//        GeometryReader { geo in
//            ScrollView(.vertical, showsIndicators: false) {
//                // LazyVStack 可以进行懒加载，这里使用 pinnedViews 可以把“现在”这个位置固定之类
//                LazyVStack(spacing: 0, pinnedViews: []) {
//                    
//                    // 为了在视图中看到连续的时间轴，做一个 ZStack：
//                    // 1. 时间刻度的线 (在左侧)
//                    // 2. 使用绝对定位(overlay)显示事件
//                    ZStack(alignment: .topLeading) {
//                        
//                        // MARK: 1) 时间刻度和时间线
//                        ForEach(timelineHours, id: \.self) { date in
//                            // 用一个垂直偏移来表示这个 hour 的位置
//                            let offsetY = offsetFrom(date: date, baseDate: timelineStart)
//                            
//                            // 在左侧绘制一条细线 + 时间文本
//                            // 这里做一个小技巧：让 line 占满屏宽，但只在最左边显示标注
//                            Group {
//                                // 时间刻度线
//                                Rectangle()
//                                    .fill(Color.secondary.opacity(0.2))
//                                    .frame(height: 1)
//                                    .position(x: geo.size.width / 2, // 让它横穿整个宽度
//                                              y: offsetY)
//                                
//                                // 时间文本（显示在左上角）
//                                Text(formatDateToHourString(date))
//                                    .font(.caption)
//                                    .foregroundColor(.secondary)
//                                    .position(x: 40, y: offsetY - 10)
//                            }
//                        }
//                        
//                        // MARK: 2) 放置事件
//                        // 在同一个 ZStack 里，用绝对定位来摆放事件
//                        ForEach(events, id: \.id) { event in
//                            let positions = calculateEventPosition(event: event)
//                            
//                            // positions.top, positions.height, positions.column
//                            // column 用来做水平方向上的堆叠，避免重叠
//                            
//                            TimelineEventView(event: event)
//                                .frame(width: 120, height: positions.height)
//                                .background(event.eventType.color.opacity(0.2))
//                                .cornerRadius(8)
//                                // x 偏移：第几列 * 130（留一点间隙）
//                                .position(x: 180 + CGFloat(positions.column) * 130,
//                                          y: positions.top + positions.height / 2)
//                        }
//                        
//                    } // end of ZStack
//                    // 指定一个最小高度，保证可以滚动
//                    .frame(height: offsetFrom(date: timelineEnd, baseDate: timelineStart) + 300)
//                    
//                } // end of LazyVStack
//            } // end of ScrollView
//        } // end of GeoReader
//    }
//    
//    // MARK: - 工具函数
//    
//    /// 根据日期计算它相对于 timelineStart 的垂直偏移
//    private func offsetFrom(date: Date, baseDate: Date) -> CGFloat {
//        // 计算 date 和 baseDate 的小时差
//        let hours = date.timeIntervalSince(baseDate) / 3600.0
//        return CGFloat(hours) * hourHeight
//    }
//    
//    /// 格式化“时:分”文本，这里仅示例写成HH:mm
//    private func formatDateToHourString(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        return formatter.string(from: date)
//    }
//    
//    /// 计算事件在时间轴上的 top、height，以及它所在的“列”索引（用于防止同时间重叠）
//    private func calculateEventPosition(event: Event) -> (top: CGFloat, height: CGFloat, column: Int) {
//        // 如果没有startTime，就给一个默认
//        guard let start = event.startTime else {
//            return (top: 100, height: 60, column: 0)
//        }
//        
//        let topOffset = offsetFrom(date: start, baseDate: timelineStart)
//        
//        // 计算事件时长对应的高度
//        let eventHeight: CGFloat
//        if let end = event.endTime {
//            let diff = end.timeIntervalSince(start)
//            let hourDiff = diff / 3600.0
//            eventHeight = max(CGFloat(hourDiff) * hourHeight, 40) // 最小40
//        } else if let dur = event.durationTime {
//            // 如果给了 durationTime (单位可能是分钟，小时，或自定义？ 这里自行调整)
//            // 假设单位是小时
//            eventHeight = max(CGFloat(dur) * hourHeight, 40)
//        } else {
//            eventHeight = 60
//        }
//        
//        // 决定这个事件的“列”索引
//        // 简单做法：查看跟它重叠的事件数量，这里可以多写一个函数进行判断
//        let overlappingCount = countOverlappingEvents(for: event)
//        
//        return (topOffset, eventHeight, overlappingCount)
//    }
//    
//    /// 检查有多少事件与当前事件重叠，用于演示如何区分“列”
//    private func countOverlappingEvents(for currentEvent: Event) -> Int {
//        guard let startA = currentEvent.startTime, let endA = currentEvent.endTime else {
//            return 0
//        }
//        // 找到所有跟当前事件重叠的事件
//        // 这里的逻辑很粗糙，你可以根据需要改进，比如严格区分 start/end 是否为 nil 的情况
//        let overlappingEvents = events.filter { ev in
//            if ev.id == currentEvent.id { return false }
//            guard let startB = ev.startTime, let endB = ev.endTime else { return false }
//            // 判定区间是否重叠
//            return !(endB <= startA || startB >= endA)
//        }
//        // 直接返回 overlap 数量作为“列”
//        // 如果希望多列正确排布，需要引入更多逻辑，比如先按startTime排序并依次分配列
//        return overlappingEvents.count
//    }
//}
//
//// MARK: - 事件视图
//
///// 单个事件在时间轴上显示的视图
//struct TimelineEventView: View {
//    let event: Event
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text(event.title)
//                .font(.headline)
//            Text(event.eventType.name)
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//        }
//        .padding(6)
//    }
//}
//
//// MARK: - 预览 & 示例数据
//
//struct TimeLineView_Previews: PreviewProvider {
//    static var previews: some View {
//        // 示例事件
//        let now = Date()
//        let calendar = Calendar.current
//        
//        // 生成一些演示事件
//      let sampleEvents: [Event] = Event.demoEvents
//        
//        TimeLineView(events: sampleEvents)
//    }
//}

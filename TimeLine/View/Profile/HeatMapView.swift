//
//  HeatMapView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/21.
//

#if os(iOS)
import SwiftUI


// MARK: - Fuck 第三方库
struct HeatMapView: View {
    let start: Date
    let end: Date
//    let data: [MMHeatmapData]
    
    init() {
        let calender = Calendar(identifier: .gregorian)
        start = calender.date(from: DateComponents(year: 2021, month: 12, day: 20))!
        end = calender.date(from: DateComponents(year: 2022, month: 4, day: 3))!
//        data = [
//            MMHeatmapData(year: 2022, month: 3, day: 10, value: 5),
//            MMHeatmapData(year: 2022, month: 4, day: 1, value: 10),
//        ]
    }
    
    var body: some View {
      Text("Map Data")
//        MMHeatmapView(start: start, end: end, data: data, style: MMHeatmapStyle(baseCellColor: UIColor(Color.accentColor), minCellColor: UIColor(Color.gray)))
//            .padding(.vertical)
//            .contextMenu {
//                // share to png
//                Button("Exprot to PNG", systemImage: "square.and.arrow.up") {
//                    
//                }
//            }
//            .padding(.horizontal)
    }
}

#endif

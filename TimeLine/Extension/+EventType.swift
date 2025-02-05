//
//  +EventType.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/2/1.
//

import Foundation

//func predictEventType(from text: String) -> EventType? {
//  do {
//    let config = MLModelConfiguration()
//    let model = try EventClassify(configuration: config)
//    let input = EventClassifyInput(text: text)
//    let prediction = try model.prediction(input: input)
//
//    let eventTypeName = prediction.label.uppercased()
//
//    let allTypes = fetchAllEventTypes()
//    return allTypes.first { $0.name == eventTypeName }
//  } catch {
//    print("Error predicting event type: \(error.localizedDescription)")
//    return nil
//  }
//}

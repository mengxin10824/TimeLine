//
//  +EventType.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/24.
//

import CoreML
import Foundation

extension EventType {
  static func predictEventType(from text: String) -> EventType? {
    do {
      let config = MLModelConfiguration()
      let model = try EventClassify(configuration: config)

      let input = EventClassifyInput(text: text)

      let prediction = try model.prediction(input: input)

      let eventTypeName = prediction.label

      return allCases.first { $0.name == eventTypeName.uppercased() }
    } catch {
      print("Error predicting event type: \(error.localizedDescription)")
      return nil
    }
  }
}

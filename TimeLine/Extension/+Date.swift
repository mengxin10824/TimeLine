//
//  +Date.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/24.
//

import Foundation

extension Date {
  func toRelateiveDateString() -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    return formatter.localizedString(for: self, relativeTo: Date())
  }
}

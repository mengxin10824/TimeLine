//
//  +Color.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/22.
//

import Foundation
import SwiftUI

extension Color {
  init(hex: String) {
    var rgb: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&rgb)

    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >> 8) & 0xFF) / 255.0
    let b = Double(rgb & 0xFF) / 255.0

    self.init(red: r, green: g, blue: b)
  }

  func toHex() -> String {
    let components = self.cgColor?.components ?? [0, 0, 0, 1]
    let r = Int(components[0] * 255)
    let g = Int(components[1] * 255)
    let b = Int(components[2] * 255)
    return String(format: "#%02X%02X%02X", r, g, b)
  }
}

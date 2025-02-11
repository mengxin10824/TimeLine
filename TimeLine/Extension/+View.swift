//
//  +View.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/2/5.
//
import SwiftUI

extension View {
  func debugView() -> some View {
    self
#if DEBUG
      .border(.blue, width: 5)
#endif
  }
}

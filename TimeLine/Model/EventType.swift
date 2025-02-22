
//
//  Type.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/19.
//
import SwiftData
import SwiftUI

@Model
final class EventType: Identifiable, Hashable {
  @Attribute(.unique)
  var id: UUID
  var name: String

  @Relationship(deleteRule: .cascade, inverse: \Event.eventType)
  var events: [Event] = []

  var colorHex: String

  var color: Color {
    Color(hex: colorHex)
  }

  init(name: String, color: Color) {
    self.id = UUID()
    self.name = name.uppercased()
    self.colorHex = color.toHex()
  }

  init(name: String, hexString: String) {
    self.id = UUID()
    self.name = name.uppercased()
    self.colorHex = hexString
  }

  static func == (lhs: EventType, rhs: EventType) -> Bool {
    return lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

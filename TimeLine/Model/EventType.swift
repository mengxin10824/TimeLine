
//
//  Type.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/19.
//
import SwiftUI
import SwiftData

@Model
final class EventType: Identifiable, CaseIterable, Hashable {
    var id: UUID
    var name: String
    var colorHex: String

    var color: Color {
        Color(hex: colorHex)
    }

    static let study = EventType(name: "STUDY", color: Color.blue)
    static let work = EventType(name: "WORK", color: Color.green)
    static let fitness = EventType(name: "FITNESS", color: Color.orange)
    static let life = EventType(name: "LIFE", color: Color.yellow)
    static let leisure = EventType(name: "LEISURE", color: Color.purple)
    static let social = EventType(name: "SOCIAL", color: Color.red)
    static let finance = EventType(name: "FINANCE", color: Color.gray)
    static let creativity = EventType(name: "CREATIVITY", color: Color.pink)

    static var allCases: [EventType] {
        [study, work, fitness, life, leisure, social, finance, creativity]
    }

    init(name: String, color: Color) {
        self.id = UUID()
        self.name = name.uppercased()
        self.colorHex = color.toHex()
    }

    init(name: String, colorHex: String) {
        self.id = UUID()
        self.name = name.uppercased()
        self.colorHex = colorHex
    }

    static func == (lhs: EventType, rhs: EventType) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

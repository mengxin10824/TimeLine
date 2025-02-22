//
//  +Color.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/1/22.
//

import SwiftUI

extension Color {
    func toHex() -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return "#000000"
        }
        
        let r = Int(round(red * 255))
        let g = Int(round(green * 255))
        let b = Int(round(blue * 255))
        let a = Int(round(alpha * 255))
        
        if a == 255 {
            return String(format: "#%02X%02X%02X", r, g, b)
        } else {
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        }
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()
        
        var hexSanitized = hex
        
        // Expand short hex codes
        if [3, 4].contains(hex.count) {
            hexSanitized = hex.map { String(repeating: $0, count: 2) }.joined()
        }
        
        // Add alpha if needed
        if hexSanitized.count == 6 {
            hexSanitized += "FF"
        }
        
        guard hexSanitized.count == 8 else {
            self.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 1)
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF000000) >> 24) / 255
        let green = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255
        let blue = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255
        let alpha = CGFloat(rgbValue & 0x000000FF) / 255
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

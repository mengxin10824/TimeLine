//
//  TodayBackgroundView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/2/7.
//

import SwiftUI

struct BackgroundView: View {
  var body: some View {
    ZStack {
      MeshGradient(
        width: 3,
        height: 3,
        points: [
          .init(0, 0), .init(0.5, 0), .init(1, 0),
          .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
          .init(0, 1), .init(0.5, 1), .init(1, 1),
        ],
        colors: [
          Color(hex: "04D5FF"), Color(hex: "283BFC"), Color(hex: "313db6"),
          Color(hex: "313db6"), Color(hex: "04D5FF"), Color(hex: "00FACA"),
          Color(hex: "c0cca1"), Color(hex: "fcffa6"), Color(hex: "fcffa6"),
        ]
      )
      
      noiseImage
        .interpolation(.none)
        .resizable(resizingMode: .tile)
        .blendMode(.screen)
        
      
    }
    .opacity(0.45)
    .ignoresSafeArea()
  }
  
  private var noiseImage: Image {
    let size = CGSize(width: 100, height: 100)
    let renderer = UIGraphicsImageRenderer(size: size)
        
    return Image(uiImage: renderer.image { context in
      let cgContext = context.cgContext
            
      for x in 0..<Int(size.width) {
        for y in 0..<Int(size.height) {
          let shouldDrawNoise = Double.random(in: 0...1) > 0.95
          if shouldDrawNoise {
            let grayValue = CGFloat.random(in: 0...1)
            cgContext.setFillColor(UIColor(white: grayValue, alpha: 1.0).cgColor)
            cgContext.fill(CGRect(x: x, y: y, width: 1, height: 1))
          }
        }
      }
    })
  }
}

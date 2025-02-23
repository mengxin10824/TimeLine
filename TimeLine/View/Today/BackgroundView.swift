//
//  TodayBackgroundView.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/2/7.
//

import SwiftUI

struct BackgroundView: View {
    @State private var animate = false
    
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
                colors: animatedColors()
            )
            .animation(Animation.linear(duration: 8)
            .repeatForever(autoreverses: true), value: animate)
            
            noiseImage
                .interpolation(.none)
                .resizable(resizingMode: .tile)
                .blendMode(.screen)
        }
        .opacity(0.45)
        .ignoresSafeArea()
        .onAppear {
            animate.toggle()
        }
    }
    
    private func animatedColors() -> [Color] {
        return [
            Color(hex: animate ? "04D5FF" : "FCFFA6"),
            Color(hex: animate ? "283BFC" : "00FACA"),
            Color(hex: animate ? "313db6" : "c0cca1"),
            Color(hex: animate ? "313db6" : "04D5FF"),
            Color(hex: animate ? "04D5FF" : "00FACA"),
            Color(hex: animate ? "00FACA" : "c0cca1"),
            Color(hex: animate ? "c0cca1" : "FCFFA6"),
            Color(hex: animate ? "fcffa6" : "283BFC"),
            Color(hex: animate ? "fcffa6" : "313db6"),
        ]
    }
  
  private var noiseImage: Image {
    let size = CGSize(width: 100, height: 100)
    let renderer = UIGraphicsImageRenderer(size: size)
        
    return Image(uiImage: renderer.image { context in
      let cgContext = context.cgContext
            
      for x in 0..<Int(size.width) {
        for y in 0..<Int(size.height) {
          // P = 0.9
          let shouldDrawNoise = Double.random(in: 0...1) > 0.9
          if shouldDrawNoise {
            let grayValue = CGFloat.random(in: 0...1)
            cgContext.setFillColor(UIColor(white: grayValue, alpha: 0.6).cgColor)
            cgContext.fill(CGRect(x: x, y: y, width: 1, height: 1))
          }
        }
      }
    })
  }
}

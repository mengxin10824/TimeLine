//
//  +View.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/2/5.
//

import SwiftUI

extension View {
    func noiseBackground(opacity: Double = 0.1) -> some View {
        ZStack {
            self.background(NoiseView(opacity: opacity))
        }
    }
}

struct NoiseView: View {
    let noiseImage: UIImage = {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        
        for _ in 0..<1000 {
            let randomX = CGFloat.random(in: 0...1)
            let randomY = CGFloat.random(in: 0...1)
            let randomColor = UIColor(white: CGFloat.random(in: 0...1), alpha: 1)
            context?.setFillColor(randomColor.cgColor)
            context?.fill(CGRect(x: randomX, y: randomY, width: 0.01, height: 0.01))
        }
        
        let noiseImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return noiseImage ?? UIImage()
    }()
    
    let opacity: Double
    
    var body: some View {
        Image(uiImage: noiseImage)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .opacity(opacity)
    }
}

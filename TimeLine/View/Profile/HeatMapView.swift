

import SwiftUI

struct HeatMapView: View {
    let data: [[Double]]
    let rowCount: Int
    let columnCount: Int
    let cellSize: CGFloat = 10
    let spacing: CGFloat = 2
    let cornerRadius: CGFloat = 2
    let animationDuration: Double = 0.5
    let themeColors: [Color] = [
        Color(red: 239/255, green: 239/255, blue: 239/255),
        Color(red: 255/255, green: 233/255, blue: 233/255),
        Color(red: 255/255, green: 184/255, blue: 184/255),
        Color(red: 255/255, green: 152/255, blue: 152/255),
        Color(red: 255/255, green: 127/255, blue: 127/255),
        Color(red: 254/255, green: 81/255, blue: 81/255),
        Color(red: 254/255, green: 64/255, blue: 64/255),
        Color(red: 238/255, green: 44/255, blue: 44/255),
    ]
    
    init(data: [[Double]], rowCount: Int, columnCount: Int) {
        self.data = data
        self.rowCount = rowCount
        self.columnCount = columnCount
    }
    
    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnCount),
            spacing: spacing
        ) {
            ForEach(data.indices, id: \.self) { row in
                ForEach(data[row].indices, id: \.self) { column in
                    let value = data[row][column]
                    let color = getThemeColor(value: value)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(color)
                        .frame(width: cellSize, height: cellSize)
                        .scaleEffect(getScaleEffect(value))
                }
            }
        }
    }
    
    private func getThemeColor(value: Double) -> Color {
        let index = min(Int(value * Double(themeColors.count - 1)), themeColors.count - 1)
        return themeColors[index]
    }
    
    private func getScaleEffect(_ value: Double) -> CGFloat {
        return 1 + value * 0.2
    }
  
}


struct ContentView: View {
    let data: [[Double]] = {
        var data = [[Double]]()
        for _ in 0..<7 {
            var row = [Double]()
            for _ in 0..<300 {
                row.append(Double.random(in: 0...1))
            }
            data.append(row)
        }
        return data
    }()
    
    var body: some View {
        HeatMapView(data: data, rowCount: 7, columnCount: 30)
            .padding()
    }
}

#Preview(body: {
  ContentView()
})

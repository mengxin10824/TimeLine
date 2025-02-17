

import SwiftUI

struct HeatMapView: View {
  let data: [[Double]]
  
  let rowCount: Int
  let columnCount: Int
  
  let cellSize: CGFloat = 10
  let spacing: CGFloat = 5
  
  let cornerRadius: CGFloat = 2
  
  let themeColors: [Color]
  
  init(data: [[Double]], tintColor: Color = .accentColor) {
    self.data = data
    
    self.rowCount = data.count
    self.columnCount = data.first?.count ?? 0
    
    self.themeColors = (0 ... 10).map { index in
      tintColor.opacity(Double(index) / 10)
    }
  }
    
  var body: some View {
    LazyVGrid(
      columns: Array(repeating: GridItem(.fixed(cellSize), spacing: spacing), count: columnCount),
      spacing: spacing
    ) {
      ForEach(0..<rowCount * columnCount, id: \.self) { index in
        let row = index / columnCount
        let column = index % columnCount
        let value = data[row][column]
          
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(getThemeColor(value: value))
          .border(Color.primary.opacity(0.1))
          .frame(width: cellSize, height: cellSize)
      }
    }
    .frame(
      width: CGFloat(columnCount) * cellSize + CGFloat(columnCount - 1) * spacing,
      height: CGFloat(rowCount) * cellSize + CGFloat(rowCount - 1) * spacing
    )
    .padding()
  }
    
  private func getThemeColor(value: Double) -> Color {
    guard value != 0 else { return .gray.opacity(0.3) }
    
    let index = min(Int(value * Double(themeColors.count - 1)), themeColors.count - 1)
    return themeColors[index]
  }
}

#Preview {
  let data: [[Double]] = {
    var data = [[Double]]()
    for _ in 0..<7 {
      var row = [Double]()
      for _ in 0..<30 {
        row.append(Double.random(in: 0 ... 1))
      }
      data.append(row)
    }
    return data
  }()
  HeatMapView(data: data)
}

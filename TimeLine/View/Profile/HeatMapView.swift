

import SwiftUI

struct HeatMapView: View {
  let data: [[Double]]
  
  let rowCount: Int
  let columnCount: Int
  
  let cellSize: CGFloat = 10
  let spacing: CGFloat = 5
  
  let cornerRadius: CGFloat = 2
  
  let themeColors: [Color]
  
  init(data: [[Int]], tintColor: Color = .accentColor) {
    self.data = data.map { row in
            row.map { value in
                switch value {
                case let x where x <= 0:
                    return 0.0
                case 1:
                    return 0.5
                case let x where x >= 2:
                    return 1.0
                default:
                    return 0.0
                }
            }
        }
    
    self.rowCount = data.count
    self.columnCount = data.first?.count ?? 0
    
    self.themeColors = (0 ... 3).map { index in
      tintColor.opacity(Double(index) / 3)
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

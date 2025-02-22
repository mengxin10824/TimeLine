
import SwiftUI

enum FilterType {
  case byType
  case byTime
  case byPriority
  case none
}

struct FilterTypeKey: EnvironmentKey {
  static var defaultValue: FilterType = .none
}

extension EnvironmentValues {
    var filterType: FilterType {
        get { self[FilterTypeKey.self] }
        set { self[FilterTypeKey.self] = newValue }
    }
}

//
//  Tips.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/2/23.
//

import TipKit

enum AllTips {
  struct AddTips: Tip {
    var title: Text {
      Text("Start to add")
    }

    var message: Text? {
      Text("Long-press to quickly add")
    }
  }

  struct FilterTips: Tip {
    var title: Text {
      Text("Go back to now")
    }

    var message: Text? {
      Text("You can also long-press to quickly filter events")
    }
  }

  struct HeatmapTips: Tip {
    var title: Text {
      Text("This is based on data from the last 30 days")
    }

    var message: Text? {
      Text("Darker colors mean more events were created or completed that day")
    }
  }

  struct EventTypePredictionTips: Tip {
    var title: Text {
      Text("AI Powered")
    }

    var message: Text? {
      Text("The AI automatically predicts your event type based on your title")
    }

    var image: Image? {
      Image(systemName: "party.popper")
    }
  }
}

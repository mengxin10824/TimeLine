//
//  ExportToPhoto.swift
//  TimeLine
//
//  Created by mengxin10824 on 2025/2/9.
//

import PhotosUI
import SwiftUI

#if os(iOS)
struct ExportToPhoto: View {
  let data: [[Int]]
  let tintColor: Color
  let secondaryTintColor: Color

  @State private var image: UIImage?
  @State private var isImagePickerPresented = false
  @State private var isImageSaved = false
  
  var days: Int {
    return data.flatMap { $0 }.filter { $0 > 0 }.count
  }
  var tasks: Int {
    return data.flatMap { $0 }.reduce(0, +)
  }

  var body: some View {
    VStack {
      if let image = image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(width: 300, height: 300)
      } else {
        Button("Export to Photos") {
          exportViewAsImage()
        }
        .buttonStyle(.bordered)
      }

      Button("Save to Photos") {
        if let image = image {
          saveImageToPhotos(image: image)
        }
      }
      .buttonStyle(.bordered)
      .padding()

      if isImageSaved {
        Text("Image saved to Photos")
          .foregroundColor(.green)
          .padding()
      }
    }
    .padding()
    .onAppear {
      exportViewAsImage()
    }
  }

  func exportViewAsImage() {
    let renderer = ImageRenderer(content: exportToPhoto())
    if let cgImage = renderer.cgImage {
      image = UIImage(cgImage: cgImage)
    }
  }

  func saveImageToPhotos(image: UIImage) {
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAsset(from: image)
    }) { success, error in
      if success {
        isImageSaved = true
      } else {
        print("Saved error: \(String(describing: error))")
      }
    }
  }

  @ViewBuilder
  func exportToPhoto() -> some View {
    ZStack {
      ZStack(alignment: .top) {
        AboveShape()
          .fill(tintColor.opacity(0.8))

        VStack(alignment: .center) {
          HeatMapView(data: data, tintColor: tintColor)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .scaleEffect(1.4)

          Spacer()

          VStack(alignment: .leading) {
            Text("TASK RECORD")
              .font(.system(size: 72, weight: .black))

            HStack(alignment: .lastTextBaseline) {
              Text(days.description)
                .font(.system(size: 84, weight: .black))

              Text("DAYS")
                .font(.system(size: 32, weight: .black))
            }
            .offset(y: 50)
          }
          .padding(.trailing, 15)
          .offset(y: 40)
        }
        .padding(.top, 80)
        .frame(width: 600, height: 400)
        .zIndex(10)
      }.frame(width: 600)

      ZStack {
        BelowShape().fill(secondaryTintColor.opacity(0.8))

        VStack {
          VStack(alignment: .trailing) {
            HStack(alignment: .lastTextBaseline) {
              Text("TASKS")
                .font(.system(size: 32, weight: .black))

              Text(tasks.description)
                .font(.system(size: 84, weight: .black))
            }

            Text("All Completed Tasks")
              .font(.system(size: 55, weight: .black))
              .fixedSize()
              .offset(y: 50)
          }
          .offset(x: 5, y: 180)
          .frame(width: 600, height: 400)

          copyRight()
            .offset(y: 150)
        }
      }
    }
    .frame(width: 600, height: 800)
  }

  @ViewBuilder
  func copyRight() -> some View {
    HStack(alignment: .lastTextBaseline) {
      Text("Powered By")
        .font(.system(size: 32, weight: .black))
      Text("TimeLine")
        .font(.system(size: 40, weight: .black))
    }
  }
}

struct AboveShape: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let width = rect.size.width
    let height = rect.size.height
    path.move(to: CGPoint(x: width, y: 0.08*height))
    path.addCurve(to: CGPoint(x: 0.87*width, y: 0), control1: CGPoint(x: width, y: 0.04*height), control2: CGPoint(x: 0.94*width, y: 0))
    path.addLine(to: CGPoint(x: 0.13*width, y: 0))
    path.addCurve(to: CGPoint(x: 0, y: 0.08*height), control1: CGPoint(x: 0.06*width, y: 0), control2: CGPoint(x: 0, y: 0.04*height))
    path.addLine(to: CGPoint(x: 0, y: 0.58*height))
    path.addCurve(to: CGPoint(x: 0.13*width, y: 0.66*height), control1: CGPoint(x: 0, y: 0.63*height), control2: CGPoint(x: 0.06*width, y: 0.66*height))
    path.addLine(to: CGPoint(x: 0.3*width, y: 0.66*height))
    path.addCurve(to: CGPoint(x: 0.4*width, y: 0.63*height), control1: CGPoint(x: 0.34*width, y: 0.66*height), control2: CGPoint(x: 0.37*width, y: 0.65*height))
    path.addLine(to: CGPoint(x: 0.57*width, y: 0.5*height))
    path.addCurve(to: CGPoint(x: 0.67*width, y: 0.47*height), control1: CGPoint(x: 0.6*width, y: 0.49*height), control2: CGPoint(x: 0.63*width, y: 0.47*height))
    path.addLine(to: CGPoint(x: 0.87*width, y: 0.47*height))
    path.addCurve(to: CGPoint(x: width, y: 0.39*height), control1: CGPoint(x: 0.94*width, y: 0.47*height), control2: CGPoint(x: width, y: 0.44*height))
    path.addLine(to: CGPoint(x: width, y: 0.08*height))
    path.closeSubpath()
    return path
  }
}

struct BelowShape: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let width = rect.size.width
    let height = rect.size.height
    path.move(to: CGPoint(x: width, y: 0.62*height))
    path.addCurve(to: CGPoint(x: 0.87*width, y: 0.54*height), control1: CGPoint(x: width, y: 0.57*height), control2: CGPoint(x: 0.94*width, y: 0.54*height))
    path.addLine(to: CGPoint(x: 0.71*width, y: 0.54*height))
    path.addCurve(to: CGPoint(x: 0.6*width, y: 0.57*height), control1: CGPoint(x: 0.67*width, y: 0.54*height), control2: CGPoint(x: 0.63*width, y: 0.55*height))
    path.addLine(to: CGPoint(x: 0.43*width, y: 0.7*height))
    path.addCurve(to: CGPoint(x: 0.33*width, y: 0.73*height), control1: CGPoint(x: 0.4*width, y: 0.72*height), control2: CGPoint(x: 0.37*width, y: 0.73*height))
    path.addLine(to: CGPoint(x: 0.13*width, y: 0.73*height))
    path.addCurve(to: CGPoint(x: 0, y: 0.81*height), control1: CGPoint(x: 0.06*width, y: 0.73*height), control2: CGPoint(x: 0, y: 0.76*height))
    path.addLine(to: CGPoint(x: 0, y: 0.92*height))
    path.addCurve(to: CGPoint(x: 0.13*width, y: height), control1: CGPoint(x: 0, y: 0.96*height), control2: CGPoint(x: 0.06*width, y: height))
    path.addLine(to: CGPoint(x: 0.87*width, y: height))
    path.addCurve(to: CGPoint(x: width, y: 0.92*height), control1: CGPoint(x: 0.94*width, y: height), control2: CGPoint(x: width, y: 0.96*height))
    path.addLine(to: CGPoint(x: width, y: 0.62*height))
    path.closeSubpath()
    return path
  }
}

#endif

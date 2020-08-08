//
//  Extensions.swift
//  SHOOT OUT
//
//  Created by James Graupera on 05/07/2018.
//  Copyright © James' Games. All rights reserved.
//

import SpriteKit
import AVFoundation

struct ScreenSize {
  static let width        = UIScreen.main.bounds.size.width
  static let height       = UIScreen.main.bounds.size.height
  static let maxLength    = max(ScreenSize.width, ScreenSize.height)
  static let minLength    = min(ScreenSize.width, ScreenSize.height)
  static let size         = CGSize(width: ScreenSize.width, height: ScreenSize.height)
}


public extension UIView {

func pb_takeSnapshot() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)

    drawHierarchy(in: self.bounds, afterScreenUpdates: true)

    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
    }
}

extension UIImage {

  func imageRotated(on degrees: CGFloat) -> UIImage {
    // Following code can only rotate images on 90, 180, 270.. degrees.
    let degrees = round(degrees / 90) * 90
    let sameOrientationType = Int(degrees) % 180 == 0
    let radians = CGFloat.pi * degrees / CGFloat(180)
    let newSize = sameOrientationType ? size : CGSize(width: size.height, height: size.width)

    UIGraphicsBeginImageContext(newSize)
    defer {
      UIGraphicsEndImageContext()
    }

    guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
      return self
    }

    ctx.translateBy(x: newSize.width / 2, y: newSize.height / 2)
    ctx.rotate(by: radians)
    ctx.scaleBy(x: 1, y: -1)
    let origin = CGPoint(x: -(size.width / 2), y: -(size.height / 2))
    let rect = CGRect(origin: origin, size: size)
    ctx.draw(cgImage, in: rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    return image ?? self
  }

}

struct DeviceType {
  static let isiPhone4OrLess = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength < 568.0
  static let isiPhone5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 568.0
  static let isiPhone6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 667.0
  static let isiPhone6Plus = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 736.0
  static let isiPhoneX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 812.0
  static let isiPad = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxLength == 1024.0
  static let isiPadPro = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxLength == 1366.0
}

public extension SKSpriteNode {
  
  func scaleTo(screenWidthPercentage: CGFloat) {
    let aspectRatio = self.size.height / self.size.width
    self.size.width = ScreenSize.width * screenWidthPercentage
    self.size.height = self.size.width * aspectRatio
  }
  
}

//
//  ImageItem.swift
//  ImageComposer
//
//  Created by Giuseppe Baccini on 18/05/2019.
//  Copyright © 2019 Giuseppe Baccini. All rights reserved.
//

import UIKit
import Foundation

struct ImageItem : Equatable, CustomStringConvertible{
    
    var description: String {
        return "[\(imageName)], x:\(x), y:\(y) width:\(width), height:\(height)"
    }
    
    var imageName: String = ""
    var geometry = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
    var scale: Double = 1
    var rotationAngle: Double = 0
    var zOrder = 0
    
    var x: CGFloat{
        get{return geometry.minX}
    }
    
    var y: CGFloat{
        get{return geometry.minY}
    }
    
    var width: CGFloat{
        get{return geometry.width}
    }
    
    var height: CGFloat{
        get{return geometry.height}
    }
    
    static func == (lhs: ImageItem, rhs: ImageItem) -> Bool {
        return lhs.imageName == rhs.imageName
    }
    
    mutating func translate(by: CGPoint){
        geometry.origin = geometry.origin.applying(CGAffineTransform.identity.translatedBy(x: by.x, y: by.y))
    }
    
    init(_ imageName: String){
        self.imageName = imageName
    }
}

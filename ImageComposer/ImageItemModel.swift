//
//  ImageItemModel.swift
//  ImageComposer
//
//  Created by Giuseppe Baccini on 18/05/2019.
//  Copyright © 2019 Giuseppe Baccini. All rights reserved.
//

import UIKit
import Foundation

class ImageItemModel{
    
    private var imageItemSet: [ImageItem]
    private var maxZOrder = 0
    
    init(){
        imageItemSet = []
    }
    
    func getImageItemSetZORdered() -> [ImageItem]{
        return imageItemSet.sorted {$0.zOrder > $1.zOrder}
    }
    
    func addImageItem(imageName: String){
        var imageItem = ImageItem(imageName)
        if !imageItemSet.contains(imageItem){
            maxZOrder += 1
            imageItem.zOrder = maxZOrder
            imageItemSet.append(imageItem)
        }
    }
    
    func moveImageItem(imageItem: ImageItem, translation: CGPoint){
        if let index = imageItemSet.firstIndex (where: { $0 == imageItem }){
            imageItemSet[index].translate(by: translation)
        }
    }
    
    func getImageItemForPoint(pointInModel: CGPoint) -> ImageItem?{
        return imageItemSet.filter { $0.geometry.contains(pointInModel) }.sorted {$0.zOrder > $1.zOrder}.first
    }
    
}

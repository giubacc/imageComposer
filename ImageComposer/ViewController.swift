//
//  ViewController.swift
//  ImageComposer
//
//  Created by Giuseppe Baccini on 18/05/2019.
//  Copyright © 2019 Giuseppe Baccini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var model = ImageItemModel()
    
    @IBOutlet weak var imageItemView: ImageItemView!{
        didSet{
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(byHandlingGestureRecognizedBy:)))
            pan.maximumNumberOfTouches = 1
            pan.minimumNumberOfTouches = 1
            imageItemView.addGestureRecognizer(pan)
        }
    }
    
    @objc func handlePanGesture(byHandlingGestureRecognizedBy recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            if let selectedImageItem = model.getImageItemForPoint(pointInModel: imageItemView.getPointInModel(pointInView: recognizer.location(in: imageItemView))){
                if let index = imageItemView.imageItems.firstIndex (where: { $0 == selectedImageItem }){
                    imageItemView.selectItem(index: index)
                }
            }else{
                imageItemView.unselectAllItems()
            }
        case .changed: fallthrough
        case .ended:
            if let selectedItem = imageItemView.selectedImageItem{
                model.moveImageItem(imageItem: selectedItem, translation: recognizer.translation(in: imageItemView))
                imageItemView.imageItems = model.getImageItemSetZORdered()
            }else{
                imageItemView.adjustOriginOffset(offset: recognizer.translation(in: imageItemView))
            }
            recognizer.setTranslation(CGPoint(), in: imageItemView)
        default:
            break
        }
    }
    
    var imageIdx = 0
    
    @IBAction func addImageItem(_ sender: UIButton) {
        model.addImageItem(imageName: "Image_\(imageIdx)")
        imageIdx += 1
        imageItemView.imageItems = model.getImageItemSetZORdered()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


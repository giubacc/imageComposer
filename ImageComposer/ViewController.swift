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
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(byHandlingGestureRecognizedBy:)))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            imageItemView.addGestureRecognizer(tap)
            
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(byHandlingGestureRecognizedBy:)))
            pan.maximumNumberOfTouches = 1
            pan.minimumNumberOfTouches = 1
            imageItemView.addGestureRecognizer(pan)
            
            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(byHandlingGestureRecognizedBy:)))
            imageItemView.addGestureRecognizer(pinch)
        }
    }
    
    @discardableResult func selectImageItem(pointInView: CGPoint) -> ImageItem?{
        if let selectedImageItem = model.getImageItemForPoint(pointInModel: imageItemView.getPointInModel(pointInView: pointInView)){
            if let index = imageItemView.imageItems.firstIndex (where: { $0 == selectedImageItem }){
                imageItemView.selectItem(index: index)
            }
            return selectedImageItem
        }else{
            imageItemView.unselectAllItems()
            return nil
        }
    }
    
    @objc func handleTapGesture(byHandlingGestureRecognizedBy recognizer: UITapGestureRecognizer){
        switch recognizer.state {
        case .ended:
            selectImageItem(pointInView: recognizer.location(in: imageItemView))
        default:
            break
        }
    }
    
    @objc func handlePanGesture(byHandlingGestureRecognizedBy recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            selectImageItem(pointInView: recognizer.location(in: imageItemView))
        case .changed: fallthrough
        case .ended:
            if let selectedItem = imageItemView.selectedImageItem{
                model.moveImageItem(imageItem: selectedItem, translation: recognizer.translation(in: imageItemView).applying(imageItemView.inModelScaleTransformation))
                imageItemView.imageItems = model.getImageItemSetZORdered()
            }else{
                imageItemView.modifyTranslationBy(offset: recognizer.translation(in: imageItemView))
            }
            recognizer.setTranslation(CGPoint(), in: imageItemView)
        default:
            break
        }
    }
    
    @objc func handlePinchGesture(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer){
        switch recognizer.state {
        case .changed: fallthrough
        case .ended:
            imageItemView.modifyScaleBy(amount: recognizer.scale)
            recognizer.scale = 1
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


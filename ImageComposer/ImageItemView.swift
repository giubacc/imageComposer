//
//  ImageItemView.swift
//  ImageComposer
//
//  Created by Giuseppe Baccini on 18/05/2019.
//  Copyright © 2019 Giuseppe Baccini. All rights reserved.
//

import UIKit

@IBDesignable
class ImageItemView: UIView {

    var imageItems: [ImageItem] = []{
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var selectedImageItem: ImageItem?{
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    private var originOffset: CGPoint = CGPoint(x:0,y:0){
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    func getPointInModel(pointInView: CGPoint) -> CGPoint{
        return pointInView.applying(CGAffineTransform.identity.translatedBy(x: -originOffset.x, y: -originOffset.y))
    }
    
    func adjustOriginOffset(offset: CGPoint){
        originOffset = originOffset.offsetBy(offset: offset)
    }
    
    private var originOffsetString: NSAttributedString {
        get{
            return getOriginOffsetString("view offset [x:\(originOffset.x), y:\(originOffset.y)]", fontSize: 10)
        }
    }
    
    private lazy var originOffsetLabel: UILabel = createOriginOffsetLabel()
    
    private func getOriginOffsetString(_ string: String, fontSize: CGFloat) -> NSAttributedString{
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        return NSAttributedString(string: string, attributes: [.font:font, .foregroundColor:UIColor.white])
    }
    
    private func createOriginOffsetLabel() -> UILabel{
        let label = UILabel()
        addSubview(label)
        return label
    }
    
    private func configureOriginOffsetLabel(){
        originOffsetLabel.attributedText = originOffsetString
        originOffsetLabel.frame.size = CGSize.zero
        originOffsetLabel.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureOriginOffsetLabel()
        originOffsetLabel.frame.origin = bounds.origin.offsetBy(dx: bounds.width/2, dy: bounds.height-20)
    }
    
    func unselectAllItems(){
        selectedImageItem = nil
    }
    
    func selectItem(index: Int){
        selectedImageItem = imageItems[index]
    }
    
    func setUpRoundRectForImageItem(roundedRect :UIBezierPath, forImgItem: ImageItem){
        if let selImgItem = selectedImageItem{
            if selImgItem == forImgItem{
                UIColor.orange.setStroke()
            }else{
                UIColor.white.setStroke()
            }
        }else{
            UIColor.white.setStroke()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext(){
            context.translateBy(x: originOffset.x, y: originOffset.y)
            context.addLines(between: [CGPoint(x: 0, y: -bounds.maxY), CGPoint(x: 0, y: bounds.maxY)])
            context.addLines(between: [CGPoint(x: -bounds.maxX, y: 0), CGPoint(x: bounds.maxX, y: 0)])
            UIColor.white.setStroke()
            context.strokePath()
        }
        imageItems.forEach { (imageItem: ImageItem) in
            let roundedRect = UIBezierPath(roundedRect: imageItem.geometry, cornerRadius: 16)
            setUpRoundRectForImageItem(roundedRect: roundedRect, forImgItem: imageItem)
            roundedRect.stroke()
        }
    }
}

extension CGPoint{
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint{
        return CGPoint(x: x+dx, y: y+dy)
    }
    func offsetBy(offset: CGPoint) -> CGPoint{
        return CGPoint(x: x+offset.x, y: y+offset.y)
    }
}

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
    
    var translation: CGPoint = CGPoint(x:0,y:0){
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var scale: CGPoint = CGPoint(x:1, y:1){
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    private var pointInModel = CGPoint(){
        didSet{
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var inModelTransformation: CGAffineTransform{
        get{
            return inViewTransformation.inverted()
        }
    }
    
    var inViewTransformation: CGAffineTransform{
        get{
            return CGAffineTransform.identity.translatedBy(x: translation.x, y: translation.y)
                    .concatenating(CGAffineTransform.identity.scaledBy(x: scale.x, y: scale.y))
        }
    }
    
    var inModelScaleTransformation: CGAffineTransform{
        get{
            return inViewScaleTransformation.inverted()
        }
    }
    
    var inViewScaleTransformation: CGAffineTransform{
        get{
            return CGAffineTransform.identity.scaledBy(x: scale.x, y: scale.y)
        }
    }
    
    func getPointInModel(pointInView: CGPoint) -> CGPoint{
        pointInModel = pointInView.applying(inModelTransformation)
        return pointInModel
    }
    
    func modifyTranslationBy(offset: CGPoint){
        translation = translation.offsetBy(offset: offset)
    }
    
    func modifyScaleBy(amount: CGFloat){
        scale.mulSameAmountXY(amount: amount)
    }
    
    private var scaleAndOriginTranslationString: NSAttributedString {
        get{
            return getNSAttributedStringForView("scale [\(scale.x)] translation [x:\(translation.x), y:\(translation.y)]", fontSize: 10)
        }
    }
    
    private var pointInModelString: NSAttributedString {
        get{
            return getNSAttributedStringForView("point in model [x:\(pointInModel.x), y:\(pointInModel.y)]", fontSize: 10)
        }
    }
    
    private lazy var originScaleAndTranslationLabel: UILabel = createLabelSubview()
    private lazy var pointInModelLabel: UILabel = createLabelSubview()
    
    private func getNSAttributedStringForView(_ string: String, fontSize: CGFloat) -> NSAttributedString{
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        return NSAttributedString(string: string, attributes: [.font:font, .foregroundColor:UIColor.white])
    }
    
    private func createLabelSubview() -> UILabel{
        let label = UILabel()
        addSubview(label)
        return label
    }
    
    private func configureLabel(_ label: UILabel, nsAttrString: NSAttributedString){
        label.attributedText = nsAttrString
        label.frame.size = CGSize.zero
        label.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLabel(originScaleAndTranslationLabel, nsAttrString: scaleAndOriginTranslationString)
        configureLabel(pointInModelLabel, nsAttrString: pointInModelString)
        originScaleAndTranslationLabel.frame.origin = bounds.origin.offsetBy(dx: bounds.minX+10, dy: bounds.height-25)
        pointInModelLabel.frame.origin = bounds.origin.offsetBy(dx: bounds.minX+10, dy: bounds.height-15)
    }
    
    func unselectAllItems(){
        selectedImageItem = nil
    }
    
    func selectItem(index: Int){
        selectedImageItem = imageItems[index]
    }
    
    func setUpRoundRectForImageItem(_ context: CGContext, roundedRect :UIBezierPath, forImgItem: ImageItem){
        var imageItemDescRect = CGRect();
        imageItemDescRect.origin = forImgItem.geometry.origin.applying(CGAffineTransform.identity.translatedBy(x: 0, y: forImgItem.height+10))
        
        //why let is allowed??
        let imageItemDesc = UILabel()
        configureLabel(imageItemDesc, nsAttrString: getNSAttributedStringForView(forImgItem.description, fontSize: 10))
        imageItemDesc.drawText(in: imageItemDescRect);
        
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
            context.concatenate(inViewTransformation)
            context.addLines(between: [CGPoint(x: 0, y: -bounds.maxY), CGPoint(x: 0, y: bounds.maxY)])
            context.addLines(between: [CGPoint(x: -bounds.maxX, y: 0), CGPoint(x: bounds.maxX, y: 0)])
            UIColor.white.setStroke()
            context.strokePath()
            imageItems.forEach { (imageItem: ImageItem) in
                let roundedRect = UIBezierPath(roundedRect: imageItem.geometry, cornerRadius: 16)
                setUpRoundRectForImageItem(context, roundedRect: roundedRect, forImgItem: imageItem)
                roundedRect.stroke()
            }
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
    mutating func addSameAmountXY(amount: CGFloat){
        x += amount
        y += amount
    }
    mutating func mulSameAmountXY(amount: CGFloat){
        x *= amount
        y *= amount
    }
    mutating func divSameAmountXY(amount: CGFloat){
        x /= amount
        y /= amount
    }
}

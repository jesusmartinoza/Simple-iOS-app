//
//  ParallaxHeader.swift
//  Olimed
//
//  Created by Jesús Martínez on 2/8/16.
//  Copyright © 2020 Jesús Martínez. All rights reserved.
//

import Foundation
import UIKit

open class ParallaxHeader {
    
    var headerView: UIView!
    var imageScrollView: UIScrollView!
    var imageView: UIImageView!
    var subView: UIView!
    var headerLabel: UILabel!
    
    fileprivate var parallaxDeltaFactor:CGFloat = 0.5
    fileprivate var tableHeaderHeight:CGFloat = 200
    fileprivate let labelPaddingDist:CGFloat = 8.0
    
    public init(){}
    
    
    open func parallaxHeaderViewWithImage(_ image: UIImage, headerSize: CGSize, title : String) -> (UIView) {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: headerSize.width, height: headerSize.height))
        initialSetupForImageHeader(image, title: title)
        return headerView
    }
    
    open func parallaxHeaderViewWithView(_ subView: UIView) -> (UIView) {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: subView.frame.size.width, height: subView.frame.size.height))
        initialSetupForViewHeader(subView)
        return headerView
    }
    
    
    open func layoutHeaderViewForScrollViewOffset(_ viewOffset: CGPoint!) {
        var frame = self.imageScrollView.frame
        
        if viewOffset.y > 0 {
            frame.origin.y = max(viewOffset.y*parallaxDeltaFactor, 0)
            self.imageScrollView.frame = frame
            self.headerView.clipsToBounds = true
        } else {
            var delta = 0.0
            var headerRect = CGRect(x: 0.0, y: 0.0, width: self.headerView.bounds.width, height: tableHeaderHeight)
            delta = fabs(min(Double(0.0), Double(viewOffset.y)))
            headerRect.origin.y -= CGFloat(delta)
            headerRect.size.height += CGFloat(delta)
            self.headerView.clipsToBounds = false
            self.imageScrollView.frame = headerRect
        }
    }
    
    fileprivate func initialSetupForImageHeader(_ image: UIImage, title : String){
        self.imageScrollView = UIScrollView(frame: headerView.bounds)
        self.imageView = UIImageView(frame: imageScrollView.bounds)
        imageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleHeight, .flexibleWidth]
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = image
        imageScrollView.addSubview(imageView)
        
        var labelRect = CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        labelRect.size.width = labelRect.size.width
        labelRect.size.height = labelRect.size.height
        
        self.headerLabel = UILabel(frame:labelRect)
        self.headerLabel.textAlignment = NSTextAlignment.center
        self.headerLabel.numberOfLines = 0
        self.headerLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.headerLabel.autoresizingMask = imageView.autoresizingMask
        self.headerLabel.textColor = UIColor.white
        self.headerLabel.text = title
        self.headerLabel.font = UIFont(name: "Avenir-Black", size: 26.0)
        self.headerLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        imageScrollView.addSubview(headerLabel)
        
        headerView.addSubview(imageScrollView)
    }
    
    fileprivate func initialSetupForViewHeader(_ subView: UIView) {
        self.imageScrollView = UIScrollView(frame: headerView.bounds)
        self.subView = subView
        subView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleHeight, .flexibleWidth]
        self.imageScrollView.addSubview(subView)
        
        headerView.addSubview(imageScrollView)
    }


    
}

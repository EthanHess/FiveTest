//  CollectionViewLayoutAttributes.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/3/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit

class CollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    var angle : CGFloat = 0 {
        
        didSet {
            
            zIndex = Int(angle * 1000000)
            transform = CGAffineTransformMakeRotation(angle)
        }
    }
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        
        let copiedAttributes : CollectionViewLayoutAttributes =
        super.copyWithZone(zone) as! CollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
}

class CircularCollectionViewLayout: UICollectionViewLayout {
    
    //adjust width
    
    let itemSize = CGSize(width: 300, height: 415)
    
    
    var angleAtExtreme: CGFloat {
        return collectionView!.numberOfItemsInSection(0) > 0 ?
            -CGFloat(collectionView!.numberOfItemsInSection(0) - 1) * anglePerItem : 0
    }
    
    var angle: CGFloat {
        return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize().width -
            CGRectGetWidth(collectionView!.bounds))
    }
    
    //radius is from bottom of top item to top of bottom item
    
    var radius : CGFloat = 500 {
        
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem : CGFloat {
        return atan(itemSize.width / radius)
    }
    
    //array of attributes
    
    var attributesList = [CollectionViewLayoutAttributes]()
    
    override func collectionViewContentSize() -> CGSize {
        
        return CGSize(width: CGFloat(collectionView!.numberOfItemsInSection(0)) * itemSize.width, height: CGRectGetHeight(collectionView!.bounds))
        
    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return CollectionViewLayoutAttributes.self
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        let itemCount = self.collectionView?.numberOfItemsInSection(0)
        if itemCount == 0 {
            return
        }
        
        
        
        let centerX = collectionView!.contentOffset.x + (CGRectGetWidth(collectionView!.bounds) / 2.0)
        
        //sets anchor point
        
        let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
        
        // 1
        let theta = atan2(CGRectGetWidth(collectionView!.bounds) / 2.0,
            radius + (itemSize.height / 2.0) - (CGRectGetHeight(collectionView!.bounds) / 2.0))
        
        // 2
        var startIndex = 0
        var endIndex = collectionView!.numberOfItemsInSection(0) - 1
        // 3
        if (angle < -theta) {
            startIndex = Int(floor((-theta - angle) / anglePerItem))
        }
        // 4
        endIndex = min(endIndex, Int(ceil((theta - angle) / anglePerItem)))
        // 5
        if (endIndex < startIndex) {
            endIndex = 0
            startIndex = 0
        }
        
        attributesList = (startIndex...endIndex).map { (i)
            -> CollectionViewLayoutAttributes in
            // 1
            let attributes = CollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: i,
                inSection: 0))
            attributes.size = self.itemSize
            // 2
            attributes.center = CGPoint(x: centerX, y: CGRectGetMidY(self.collectionView!.bounds))
            // 3
            attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            
            
            
            return attributes
        }
        
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return attributesList
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath)
        -> UICollectionViewLayoutAttributes! {
            return attributesList[indexPath.row]
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
}


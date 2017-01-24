//
//  FoodTrackerLayout.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 1/23/17.
//  Copyright © 2017 Eric Rose. All rights reserved.
//

import UIKit

class FoodTrackerLayout: UICollectionViewLayout {

    private let numberOfColumns = 10
    private let padding: CGFloat = 4.0
    
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        get {
            let insets = collectionView!.contentInset
            return collectionView!.bounds.width - (insets.left + insets.right)
        }
    }
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        if cache.isEmpty {
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            let itemWidth = columnWidth - CGFloat(2) * (padding)
            
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            
            var column = 0
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                
                let width = itemWidth
                let height = 50 - 2 * padding
                let frame = CGRect(x: xOffset[column], y: CGFloat(0), width: width, height: CGFloat(height))
                let insetFrame = frame.insetBy(dx: padding, dy: padding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                
                column += 1
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: contentWidth, height: contentHeight)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                layoutAttributes.append(attribute)
            }
        }
        
        return layoutAttributes
    }
    
}

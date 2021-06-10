//
//  PinVisibleCollectionViewLayout.swift
//  hzcp
//
//  Created by chengbin on 2021/1/21.
//  Copyright © 2021 HIK inc. All rights reserved.
//

import UIKit

@objc public protocol PinVisibleCollectionViewDelegateLayout: WaterfallCollectionViewDelegateLayout {
//    @objc optional func collectionView(_ collectionView: UICollectionView,
//                                       layout collectionViewLayout: UICollectionViewLayout,
//                                       pinOffsetYFor section: Int) -> CGFloat
//    @available(*, unavailable, renamed: "collectionView(_:layout:pinOffsetYFor:)")
//    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//                                       pinOffsetYForSection section: Int) -> CGFloat
}

/// 视图重叠(搭边)布局
public class PinVisibleCollectionViewLayout: WaterfallCollectionViewLayout {
    public var pinOffsetY: CGFloat = 0
    
    private var _delegate: PinVisibleCollectionViewDelegateLayout? {
        return self.delegate as? PinVisibleCollectionViewDelegateLayout
    }

    override public init() {
        super.init()
        shouldInvalidateLayout = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        shouldInvalidateLayout = true
    }

    override public func prepare() {
        super.prepare()
    }

    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return shouldInvalidateLayout || newBounds.width != collectionView?.bounds.width
    }

    override public var collectionViewContentSize: CGSize {
        var size = super.collectionViewContentSize
        if size.equalTo(.zero) {
            return .zero
        }
        size.height -= pinOffsetY
        return size
    }
    // swiftlint:disable cyclomatic_complexity function_body_length
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
        var attributes = allItemAttributes
        
        guard !attributes.isEmpty else {
            return attributes
        }
        guard let collectionView = collectionView else {
            return attributes
        }
        let numberOfSections = collectionView.numberOfSections
        if numberOfSections == 0 {
            return attributes
        }
        
        var allAttributesInSectionZero: [UICollectionViewLayoutAttributes] = []
        
        let firstIndexPath = IndexPath(item: 0, section: 0)
        let heightHeader = delegate?.collectionView?(collectionView, layout: self, heightForHeaderIn: 0)
            ?? self.headerHeight
        if heightHeader > 0 {
            let sectionHeaderAttibutes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: firstIndexPath)
            allAttributesInSectionZero.append(sectionHeaderAttibutes)
        }
        
        let numberOfItemsInSectionZero = collectionView.numberOfItems(inSection: 0)
        var row = 0
        while numberOfItemsInSectionZero > 0, row < numberOfItemsInSectionZero {
            let item = layoutAttributesForItem(at: IndexPath(item: row, section: 0))
            if let item = item {
                allAttributesInSectionZero.append(item)
            }
            row += 1
        }
        
        let footerHeight = delegate?.collectionView?(collectionView, layout: self, heightForFooterIn: 0) ?? self.footerHeight
        if footerHeight > 0 {
            let sectionFooterAttibutes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: firstIndexPath)
            allAttributesInSectionZero.append(sectionFooterAttibutes)
        }
        
        let allAttributes = decoratorAttibutes
        for attr in allAttributes {
            attributes.append(attr)
        }
        
        var results: [UICollectionViewLayoutAttributes] = []
        for item in attributes {
            results.append(item)
            /// 排除第0个section下的所有Attribute
            if allAttributesInSectionZero.contains(item) {
                if item.representedElementCategory == .decorationView {
                    /// decorationView 视图层级在最下面
                    item.zIndex = -10
                } else {
                    item.zIndex = 1
                }
                continue
            }
            /// 调整非第0个section下的所有attribute的y坐标
            let offsetY = pinOffsetY

            var frame = item.frame
            frame.origin.y -= offsetY
            item.frame = frame
            if item.representedElementCategory != .decorationView {
                /// 非decorationView视图层级在最上面
                item.zIndex = 10
            }
        }
        return results.filter {
            $0.frame.intersects(rect)
        }
    }

    override public func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
        guard let attribute = attr else { return nil }
        guard let collectionView = collectionView else {
            return attribute
        }
        let numberOfSections = collectionView.numberOfSections
        if numberOfSections == 0 {
            return attribute
        }
        if indexPath.section > 0 {
            attribute.zIndex = 2
        }
        return attribute
    }
}


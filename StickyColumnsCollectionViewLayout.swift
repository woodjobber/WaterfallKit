//
//  StickyColumnsCollectionViewLayout.swift
//  Pods-WaterfallKit_Example
//
//  Created by chengbin on 2021/6/10.
//

import UIKit

@objc public protocol StickyColumnsCollectionViewDelegateLayout: PinVisibleCollectionViewDelegateLayout {}
/// 固定第0个section下的item, 第0个SectionHeader,SectionFooter 的高度请设置0，
public class StickyColumnsCollectionViewLayout: PinVisibleCollectionViewLayout {
    /// 控制头部是否随着下拉增大
    var isStretchyEnable: Bool = false
    
    private var _delegate: StickyColumnsCollectionViewDelegateLayout? {
        return self.delegate as? StickyColumnsCollectionViewDelegateLayout
    }

    override public init() {
        super.init()
        shouldInvalidateLayout = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        shouldInvalidateLayout = true
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return shouldInvalidateLayout || newBounds.width != collectionView?.bounds.width
    }
    // swiftlint:disable cyclomatic_complexity function_body_length
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return super.layoutAttributesForElements(in: rect)
        }
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
        
        var isExistSectionHeader = false
        if heightHeader > 0 {
            let sectionHeaderAttibutes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: firstIndexPath)
            allAttributesInSectionZero.append(sectionHeaderAttibutes)
            isExistSectionHeader = true
        }
        
        var isExistItem = false
        
        let numberOfItemsInSectionZero = collectionView.numberOfItems(inSection: 0)
        var row = 0
        while numberOfItemsInSectionZero > 0, row < numberOfItemsInSectionZero {
            let item = layoutAttributesForItem(at: IndexPath(item: row, section: 0))
            if let item = item {
                allAttributesInSectionZero.append(item)
                isExistItem = true
            }
            row += 1
        }
        
        let footerHeight = delegate?.collectionView?(collectionView, layout: self, heightForFooterIn: 0) ?? self.footerHeight
        if footerHeight > 0 {
            let sectionFooterAttibutes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: firstIndexPath)
            allAttributesInSectionZero.append(sectionFooterAttibutes)
        }
                
        let offset = collectionView.contentOffset
        if offset.y <= 0 {
            let deltaY = offset.y
            for attrs in attributes {
                if allAttributesInSectionZero.contains(attrs) {
                    /// 排除 存在SectionHeader 与 SectionFooter情况下的item
                    if isExistSectionHeader, attrs.representedElementKind != UICollectionView.elementKindSectionHeader {
                        /// 1. 可调整非SectionHeader下的Attribute
                        continue
                    } else if isExistItem, attrs.representedElementKind != nil {
                        /// 2. 可调整SectionHeader的Attribute
                        continue
                    }
                    
                    /// 调整第0个section下的item的Attribute
                    /// 如果需要调整sectionHeader,需要把下面代码放入到上部分代码块中(1/2)
                    var headerRect = attrs.frame
                    if isStretchyEnable {
                        headerRect.size.height = headerRect.height - deltaY
                    }
                    /// 固定头部，用偏移量控制y坐标
                    headerRect.origin.y += deltaY
                    attrs.frame = headerRect
                    break
                }
            }
        }
        
        return attributes.filter {
            $0.frame.intersects(rect)
        }
    }
}

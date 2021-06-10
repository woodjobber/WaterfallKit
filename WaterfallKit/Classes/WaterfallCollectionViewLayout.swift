//
//  WaterfallCollectionViewLayout.swift
//  eLicense
//
//  Created by chengbin on 2020/5/19.
//  Copyright © 2020 Hik inc. All rights reserved.
//
// swiftlint:disable identifier_name type_name type_body_length file_length
import UIKit
private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

private func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

@objc public protocol WaterfallCollectionViewDelegateLayout: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize

    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       heightForHeaderIn section: Int) -> CGFloat

    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       heightForFooterIn section: Int) -> CGFloat

    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       insetsFor section: Int) -> UIEdgeInsets

    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       minimumInteritemSpacingFor section: Int) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       minimumLineSpacingFor section: Int) -> CGFloat

    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       columnCountFor section: Int) -> Int
    
    @available(*, unavailable, renamed: "collectionView(_:layout:sizeForItemAt:)")
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                       sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize

    @available(*, unavailable, renamed: "collectionView(_:layout:heightForHeaderIn:)")
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                       heightForHeaderInSection section: Int) -> CGFloat

    @available(*, unavailable, renamed: "collectionView(_:layout:heightForFooterIn:)")
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                       heightForFooterInSection section: Int) -> CGFloat

    @available(*, unavailable, renamed: "collectionView(_:layout:insetsFor:)")
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                       insetForSectionAtIndex section: Int) -> UIEdgeInsets

    @available(*, unavailable, renamed: "collectionView(_:layout:minimumInteritemSpacingFor:)")
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                       minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat

    @available(*, unavailable, renamed: "collectionView(_:layout:minimumLineSpacingFor:)")
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                       minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat

    @available(*, unavailable, renamed: "collectionView(_:layout:columnCountFor:)")
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                       columnCountForSection section: Int) -> Int
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       excludeDecorationViewFor section: Int) -> Bool
    @available(*, unavailable, renamed: "collectionView(_:layout:excludeDecorationViewFor:)")
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, excludeDecorationViewForSection section: Int) -> Bool
    
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, decoratorInsetsFor section: Int) -> UIEdgeInsets
    
    @available(*, unavailable, renamed: "collectionView(_:layout:decoratorInsetsFor:)")
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, decoratorInsetsForSection section: Int) -> UIEdgeInsets
    
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, decoratorCornerFor section: Int) -> UIRectCorner
}

@available(*, unavailable, renamed: "WaterfallCollectionViewLayout.ItemRenderDirection")
public enum WaterfallCollectionViewLayoutItemRenderDirection {}

public extension WaterfallCollectionViewLayout.ItemRenderDirection {
    @available(*, unavailable, renamed: "shortestFirst")
    static let waterfallCollectionViewLayoutItemRenderDirectionShortestFirst = 0
    @available(*, unavailable, renamed: "leftToRight")
    static let waterfallCollectionViewLayoutItemRenderDirectionLeftToRight = 1
    @available(*, unavailable, renamed: "rightToLeft")
    static let waterfallCollectionViewLayoutItemRenderDirectionRightToLeft = 2
}

extension WaterfallCollectionViewLayout {
    public enum ItemRenderDirection: Int {
        case shortestFirst
        case leftToRight
        case rightToLeft
    }

    public enum SectionInsetReference {
        case fromContentInset
        case fromLayoutMargins
        @available(iOS 11, *)
        case fromSafeArea
    }
}

@available(*, unavailable, renamed: "UICollectionView.elementKindSectionHeader")
public let WaterfallCollectionViewElementKindSectionHeader = "WaterfallCollectionViewElementKindSectionHeader"
@available(*, unavailable, renamed: "UICollectionView.elementKindSectionFooter")
public let WaterfallCollectionViewElementKindSectionFooter = "WaterfallCollectionViewElementKindSectionFooter"
public class WaterfallCollectionViewLayout: UICollectionViewLayout {
    public var columnCount: Int = 2 {
        didSet {
            invalidateLayout()
        }
    }

    /// 列之间的最小距离  minimumColumnSpacing
    public var minimumInteritemSpacing: CGFloat = 10 {
        didSet {
            invalidateLayout()
        }
    }

    public var minimumLineSpacing: CGFloat = 10 {
        didSet {
            invalidateLayout()
        }
    }

    public var headerHeight: CGFloat = 0 {
        didSet {
            invalidateLayout()
        }
    }

    public var footerHeight: CGFloat = 0 {
        didSet {
            invalidateLayout()
        }
    }

    public var sectionInset: UIEdgeInsets = .zero {
        didSet {
            invalidateLayout()
        }
    }

    public var itemRenderDirection: ItemRenderDirection = .shortestFirst {
        didSet {
            invalidateLayout()
        }
    }

    public var sectionInsetReference: SectionInsetReference = .fromContentInset {
        didSet {
            invalidateLayout()
        }
    }

    public var delegate: WaterfallCollectionViewDelegateLayout? {
        guard collectionView != nil else {
            return nil
        }
        return collectionView!.delegate as? WaterfallCollectionViewDelegateLayout
    }
    /// decorator's view color
    public var decoratorColor: UIColor = .white {
        didSet {
            invalidateLayout()
        }
    }
    /// decorator's view edgeInsets
    public var decoratorEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            invalidateLayout()
        }
    }
    /// decorator's view corner
    public var decoratorCorner: UIRectCorner = .allCorners {
        didSet {
            invalidateLayout()
        }
    }
    /// decorator's view cornerRadius
    public var decoratorCornerRadius: CGFloat = 0 {
        didSet {
            invalidateLayout()
        }
    }
    /// decorator's superview color
    public var decoratorOfSuperviewColor: UIColor = .clear {
        didSet {
            invalidateLayout()
        }
    }
    /// 是否增加装饰视图
    public var isDecoratorEnable: Bool = false
    
    /// 滑动时，控制是否实时布局
    public var shouldInvalidateLayout: Bool = true
    
    public static let elementKindDecorationView: String = WaterfallCollectionReusableView.REUSE_ID
    
    private var columnHeights: [[CGFloat]] = []
    private var sectionItemAttributes: [[UICollectionViewLayoutAttributes]] = []
    private(set)var allItemAttributes: [UICollectionViewLayoutAttributes] = []
    private var headersAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
    private var footersAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
    private(set) var decoratorAttibutes: [UICollectionViewLayoutAttributes] = []
    private var unionRects: [CGRect] = []
    private let unionSize = 20
    private let scale = UIScreen.main.scale
    
    private func columnCount(forSection section: Int) -> Int {
        return delegate?.collectionView?(collectionView!, layout: self, columnCountFor: section) ?? columnCount
    }

    private var collectionViewContentWidth: CGFloat {
        guard collectionView != nil else {
            return 0
        }
        let insets: UIEdgeInsets
        switch sectionInsetReference {
        case .fromContentInset:
            insets = collectionView!.contentInset
        case .fromSafeArea:
            if #available(iOS 11.0, *) {
                insets = collectionView!.safeAreaInsets
            } else {
                insets = .zero
            }
        case .fromLayoutMargins:
            insets = collectionView!.layoutMargins
        }
        return collectionView!.bounds.size.width - insets.left - insets.right
    }

    private func collectionViewContentWidth(ofSection section: Int) -> CGFloat {
        let insets = delegate?.collectionView?(collectionView!, layout: self, insetsFor: section) ?? sectionInset
        return collectionViewContentWidth - insets.left - insets.right
    }

    @available(*, unavailable, renamed: "itemWidth(inSection:)")
    public func itemWidthInSectionAtIndex(_ section: Int) -> CGFloat {
        return itemWidth(inSection: section)
    }

    public func itemWidth(inSection section: Int) -> CGFloat {
        let columnCount = self.columnCount(forSection: section)
        let spaceColumCount = CGFloat(columnCount - 1)
        let width = collectionViewContentWidth(ofSection: section)
        let minimumInterSpacing = delegate?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingFor: section)
            ?? minimumInteritemSpacing
        
        let floorWidth = floor((width - (spaceColumCount * minimumInterSpacing)) * scale / CGFloat(columnCount)) / scale
        return floorWidth
    }
    
    // swiftlint:disable function_body_length
    // swiftlint:disable:next cyclomatic_complexity
    public override func prepare() {
        super.prepare()
        guard collectionView != nil else {
            return
        }
        // This function is available in iOS 10. Disable it for dynamic position of `SupplementaryView `.
        // At iOS 10, a new feature is introduced, it is Cell Prefetching. It will let
        // dynamic position of SupplementaryView crash. In order to run in the old behavior,
        // it needs to disable prefetchingEnabled. It's true by default at iOS 10.
        if #available(iOS 10.0, *) {
            collectionView?.isPrefetchingEnabled = false
        }
        
        headersAttributes = [:]
        footersAttributes = [:]
        unionRects = []
        allItemAttributes = []
        sectionItemAttributes = []
        decoratorAttibutes = []
        columnHeights = []
        register(WaterfallCollectionReusableView.self, forDecorationViewOfKind: WaterfallCollectionReusableView.REUSE_ID)
        let numberOfSections = collectionView!.numberOfSections
        columnHeights = (0 ..< numberOfSections).map { section in
            let columnCount = self.columnCount(forSection: section)
            let sectionColumnHeights = (0 ..< columnCount).map { CGFloat($0) }
            return sectionColumnHeights
        }

        var top: CGFloat = 0.0
        var attributes = UICollectionViewLayoutAttributes()

        for section in 0 ..< numberOfSections {
            // MARK: 1. Get section-specific metrics (minimumLineSpacing, sectionInset)

            let minimumLineItemSpacing = delegate?.collectionView?(collectionView!, layout: self, minimumLineSpacingFor: section)
                ?? minimumLineSpacing
            let sectionInsets = delegate?.collectionView?(collectionView!, layout: self, insetsFor: section) ?? sectionInset
            let columnCount = columnHeights[section].count
            let itemWidth = self.itemWidth(inSection: section)

            // MARK: 2. Section header

            let heightHeader = delegate?.collectionView?(collectionView!, layout: self, heightForHeaderIn: section)
                ?? headerHeight
            if heightHeader > 0 {
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(row: 0, section: section))
                attributes.frame = CGRect(x: 0, y: top, width: collectionView!.bounds.size.width, height: heightHeader)
                headersAttributes[section] = attributes
                allItemAttributes.append(attributes)

                top = attributes.frame.maxY
            }
            top += sectionInsets.top
            columnHeights[section] = [CGFloat](repeating: top, count: columnCount)

            // MARK: 3. Section items

            let itemCount = collectionView!.numberOfItems(inSection: section)
            var itemAttributes: [UICollectionViewLayoutAttributes] = []

            // Item will be put into shortest column.
            for idx in 0 ..< itemCount {
                let indexPath = IndexPath(item: idx, section: section)

                let columnIndex = nextColumnIndexForItem(idx, inSection: section)
                let minimumInterSpacing = delegate?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingFor: section)
                    ?? minimumInteritemSpacing
                let xOffset = sectionInsets.left + (itemWidth + minimumInterSpacing) * CGFloat(columnIndex)

                let yOffset = columnHeights[section][columnIndex]
                var itemHeight: CGFloat = 0.0
                if let itemSize = delegate?.collectionView(collectionView!, layout: self, sizeForItemAt: indexPath),
                    itemSize.height > 0 {
                    itemHeight = itemSize.height
                    if itemSize.width > 0 {
                        itemHeight = floor(itemHeight * itemWidth / itemSize.width)
                    } // else use default item width based on other parameters
                }
                
                attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                itemAttributes.append(attributes)
                allItemAttributes.append(attributes)
                columnHeights[section][columnIndex] = attributes.frame.maxY + minimumLineItemSpacing
            }
            sectionItemAttributes.append(itemAttributes)

            // MARK: 4. Section footer

            let columnIndex = longestColumnIndex(inSection: section)
            top = columnHeights[section][columnIndex] - minimumLineItemSpacing + sectionInsets.bottom
            let footerHeight = delegate?.collectionView?(collectionView!, layout: self, heightForFooterIn: section) ?? self.footerHeight

            if footerHeight > 0 {
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: 0, y: top, width: collectionView!.bounds.size.width, height: footerHeight)
                footersAttributes[section] = attributes
                allItemAttributes.append(attributes)
                top = attributes.frame.maxY
            }
            
            columnHeights[section] = [CGFloat](repeating: top, count: columnCount)
        }
        
//        var allAttributes: [UICollectionViewLayoutAttributes] = []
        let numOfSections = self.collectionView?.numberOfSections ?? 0
        var section = 0
        
        while  section < numOfSections, isDecoratorEnable {
            let numOfItems = self.collectionView?.numberOfItems(inSection: section) ?? 0
            if numOfItems > 0 {
                let excludeSectionZeroOfDecorator = delegate?.collectionView?(collectionView!, layout: self, excludeDecorationViewFor: section) ?? false
                if !excludeSectionZeroOfDecorator {
                    let indexPath = IndexPath(item: 0, section: section)
                    let decorator = self.layoutAttributesForDecorationView(ofKind: WaterfallCollectionReusableView.REUSE_ID, at: indexPath)
                    if let decorator = decorator {
                        decoratorAttibutes.append(decorator)
                    }
                }
            }
            section += 1
        }
      
//        for attr in allAttributes {
//            if rect.intersects(attr.frame) {
//                attributes.append(attr)
//            }
//        }
        
        var idx = 0
        let itemCounts = allItemAttributes.count
        while idx < itemCounts {
            let rect1 = allItemAttributes[idx].frame
            idx = min(idx + unionSize, itemCounts) - 1
            let rect2 = allItemAttributes[idx].frame
            unionRects.append(rect1.union(rect2))
            idx += 1
        }
    }
 
    public override var collectionViewContentSize: CGSize {
        guard collectionView != nil else {
            return .zero
        }
        if collectionView!.numberOfSections == 0 {
            return .zero
        }

        var contentSize = collectionView!.bounds.size
        contentSize.width = collectionViewContentWidth

        if let height = columnHeights.last?.first {
            contentSize.height = height
            return contentSize
        }
        return .zero
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section >= sectionItemAttributes.count {
            return nil
        }
        let list = sectionItemAttributes[indexPath.section]
        if indexPath.item >= list.count {
            return nil
        }
        return list[indexPath.item]
    }

    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        var attribute: UICollectionViewLayoutAttributes?
        if elementKind == UICollectionView.elementKindSectionHeader {
            attribute = headersAttributes[indexPath.section]
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            attribute = footersAttributes[indexPath.section]
        }
        return attribute ?? UICollectionViewLayoutAttributes()
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var begin = 0, end = unionRects.count

        if let i = unionRects.firstIndex(where: { rect.intersects($0) }) {
            begin = i * unionSize
        }
        if let i = unionRects.lastIndex(where: { rect.intersects($0) }) {
            end = min((i + 1) * unionSize, allItemAttributes.count)
        }
        var attributes = allItemAttributes[begin ..< end]
            .filter { rect.intersects($0.frame) }
        let allAttributes = decoratorAttibutes
        for attr in allAttributes {
            if rect.intersects(attr.frame) {
                attributes.append(attr)
            }
        }
        return attributes
    }
    public override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let numOfSections = self.collectionView?.numberOfSections ?? 0
        guard isDecoratorEnable, numOfSections > 0, elementKind == WaterfallCollectionReusableView.REUSE_ID else {
            return nil
        }

        let section = indexPath.section
        let numOfItems = self.collectionView?.numberOfItems(inSection: section) ?? 0
        if numOfItems > 0 {
            let indexPath = IndexPath(item: 0, section: section)
            let lastIndexPath = IndexPath(item: numOfItems - 1, section: section)
            let firstItem = self.layoutAttributesForItem(at: indexPath)!
            let lastItem = self.layoutAttributesForItem(at: lastIndexPath)!
            var frame = CGRect.zero
            frame.origin = CGPoint(x: 0, y: firstItem.frame.minY)
            frame.size.width = collectionViewContentSize.width
            frame.size.height = lastItem.frame.maxY - firstItem.frame.minY
            
            let insets = delegate?.collectionView?(collectionView!, layout: self, decoratorInsetsFor: section) ?? decoratorEdgeInsets
            let corner = delegate?.collectionView?(collectionView!, layout: self, decoratorCornerFor: section) ?? decoratorCorner
            
            let decorator = WaterfallCollectionViewLayoutAttributes(forDecorationViewOfKind: WaterfallCollectionReusableView.REUSE_ID, with: IndexPath(item: 0, section: section))
      
            decorator.frame = frame
            decorator.zIndex = -10
            decorator.corner = corner
            decorator.cornerRadius = decoratorCornerRadius
            decorator.color = decoratorColor
            decorator.edgeInsets = insets
            decorator.decoratorOfSuperviewColor = decoratorOfSuperviewColor
            return decorator
        }
        return nil
    }
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.width != collectionView?.bounds.width || shouldInvalidateLayout
    }

    /// Find the shortest column.
    ///
    /// - Returns: index for the shortest column
    private func shortestColumnIndex(inSection section: Int) -> Int {
        return columnHeights[section].enumerated()
            .min(by: { $0.element < $1.element })?
            .offset ?? 0
    }

    /// Find the longest column.
    ///
    /// - Returns: index for the longest column
    private func longestColumnIndex(inSection section: Int) -> Int {
        return columnHeights[section].enumerated()
            .max(by: { $0.element < $1.element })?
            .offset ?? 0
    }

    /// Find the index for the next column.
    ///
    /// - Returns: index for the next column
    private func nextColumnIndexForItem(_ item: Int, inSection section: Int) -> Int {
        var index = 0
        let columnCount = self.columnCount(forSection: section)
        switch itemRenderDirection {
        case .shortestFirst:
            index = shortestColumnIndex(inSection: section)
        case .leftToRight:
            index = item % columnCount
        case .rightToLeft:
            index = (columnCount - 1) - (item % columnCount)
        }
        return index
    }
}

// MARK: DecorationView

private class WaterfallCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var color: UIColor = .white
    var decoratorOfSuperviewColor: UIColor = UIColor(red: 0.94, green: 0.96, blue: 0.98, alpha: 1)
    var edgeInsets: UIEdgeInsets = .zero
    var corner: UIRectCorner = .allCorners
    var cornerRadius: CGFloat = 10
    override init() {
        super.init()
        zIndex = -10
    }
    override func copy(with zone: NSZone?) -> Any {
        let newAttributes: WaterfallCollectionViewLayoutAttributes = super.copy(with: zone) as! WaterfallCollectionViewLayoutAttributes
        newAttributes.color = self.color.copy(with: zone) as! UIColor
        newAttributes.edgeInsets = self.edgeInsets
        newAttributes.corner = self.corner
        newAttributes.cornerRadius = self.cornerRadius
        return newAttributes
    }
}

private class WaterfallCollectionReusableView: UICollectionReusableView {
    static var REUSE_ID = "WaterfallCollectionReusableView"
    
    var corner: UIRectCorner = .allCorners
    var cornerRadius: CGFloat = 0
    
    private var decorationView: UIView = UIView()
    
    override var reuseIdentifier: String? {
        return WaterfallCollectionReusableView.REUSE_ID
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.customInit()
    }

    func customInit() {
        self.backgroundColor = UIColor(red: 0.94, green: 0.96, blue: 0.98, alpha: 1)
        self.clipsToBounds = false
        decorationView.backgroundColor = .white
        addSubview(decorationView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        _corner(byRoundingCorners: corner, radii: cornerRadius)
    }
    private func _corner(byRoundingCorners corners: UIRectCorner = .allCorners, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: decorationView.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = decorationView.bounds
        maskLayer.path = maskPath.cgPath
        decorationView.layer.mask = maskLayer
    }
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? WaterfallCollectionViewLayoutAttributes else {
            return
        }

        self.backgroundColor = attributes.decoratorOfSuperviewColor
        decorationView.backgroundColor = attributes.color
        self.layer.zPosition = CGFloat(attributes.zIndex)
        var frame = attributes.frame
        let insets = attributes.edgeInsets
        frame.size.width -= (insets.left + insets.right)
        frame.size.height -= (insets.top + insets.bottom)
        decorationView.frame = CGRect(x: insets.left, y: insets.top, width: frame.width, height: frame.height)
        self.corner = attributes.corner
        self.cornerRadius = attributes.cornerRadius
    }
}


//
//  TimetableLayout.swift
//  Mufe
//
//  Created by 신혜연 on 11/19/25.
//

import UIKit

protocol TimetableLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, startTimeFor indexPath: IndexPath) -> String
    func collectionView(_ collectionView: UICollectionView, endTimeFor indexPath: IndexPath) -> String
    func collectionView(_ collectionView: UICollectionView, stageIndexFor indexPath: IndexPath) -> Int
}

final class TimetableLayout: UICollectionViewLayout {
    
    weak var delegate: TimetableLayoutDelegate?
    
    // MARK: - Settings
    let stageHeaderHeight: CGFloat = 70
    let timeSidebarWidth: CGFloat = 70
    let columnWidth: CGFloat = 160
    let cellMargin: CGFloat = 16
    let heightPerMinute: CGFloat = 2.6     // 10분 단위 간격이 26pt
    let cellTopOffset: CGFloat = 9
    let startTimeOffset: CGFloat = 10
    
    let startHour = 11
    let endHour = 22
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentBounds: CGRect = .zero
    
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        cache.removeAll()
        
        let totalMinutes = (endHour - startHour) * 60
        let contentHeight = CGFloat(totalMinutes) * heightPerMinute + stageHeaderHeight
        let numberOfStages = collectionView.numberOfSections
        let contentWidth = CGFloat(numberOfStages) * columnWidth + timeSidebarWidth
        
        contentBounds = CGRect(x: 0, y: 0, width: contentWidth, height: contentHeight)
        
        // 아티스트 셀 배치
        for section in 0..<numberOfStages {
            let items = collectionView.numberOfItems(inSection: section)
            for item in 0..<items {
                let indexPath = IndexPath(item: item, section: section)
                
                guard let startTime = delegate?.collectionView(collectionView, startTimeFor: indexPath),
                      let endTime = delegate?.collectionView(collectionView, endTimeFor: indexPath) else { continue }
                
                let startMin = convertToMinutes(time: startTime)
                let endMin = convertToMinutes(time: endTime)
                let duration = CGFloat(endMin - startMin)
                let xPos = timeSidebarWidth + (CGFloat(section) * columnWidth) + (cellMargin / 2)
                let yPos = stageHeaderHeight + startTimeOffset + (CGFloat(startMin) * heightPerMinute) + cellTopOffset
                let width = columnWidth - cellMargin
                let height = duration * heightPerMinute
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
                attributes.zIndex = 5
                cache.append(attributes)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        guard let collectionView = collectionView else { return nil }
        let offset = collectionView.contentOffset
        
        // 일반 셀
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        // Stage Header (Sticky)
        let numberOfStages = collectionView.numberOfSections
        for section in 0..<numberOfStages {
            let indexPath = IndexPath(item: 0, section: section)
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "StageHeader", with: indexPath)
            
            let xPos = timeSidebarWidth + (CGFloat(section) * columnWidth)
            let yPos = max(0, offset.y)
            
            attributes.frame = CGRect(x: xPos, y: yPos, width: columnWidth, height: stageHeaderHeight)
            attributes.zIndex = 20
            visibleLayoutAttributes.append(attributes)
        }
        
        // Time Sidebar (Sticky)
        for hour in startHour..<endHour {
            let index = hour - startHour
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "TimeSidebar", with: indexPath)
            
            let xPos = offset.x
            let startMin = index * 60
            let yPos = stageHeaderHeight + startTimeOffset + (CGFloat(startMin) * heightPerMinute)
            let height = 60 * heightPerMinute
            
            attributes.frame = CGRect(x: xPos, y: yPos, width: timeSidebarWidth, height: height)
            attributes.zIndex = 30
            visibleLayoutAttributes.append(attributes)
        }
        
        // Corner Header (Sticky)
        let cornerAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "CornerHeader", with: IndexPath(item: 0, section: 0))
        cornerAttr.frame = CGRect(x: offset.x, y: max(0, offset.y), width: timeSidebarWidth, height: stageHeaderHeight)
        cornerAttr.zIndex = 100
        visibleLayoutAttributes.append(cornerAttr)
        
        return visibleLayoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private func convertToMinutes(time: String) -> Int {
        let components = time.split(separator: ":").compactMap { Int($0) }
        guard components.count == 2 else { return 0 }
        return (components[0] * 60 + components[1]) - (startHour * 60)
    }
}

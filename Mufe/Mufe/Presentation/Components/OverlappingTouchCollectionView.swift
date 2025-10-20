//
//  OverlappingTouchCollectionView.swift
//  Mufe
//
//  Created by 신혜연 on 10/20/25.
//

import UIKit

// 'x' 버튼 눌릴 수 있게 확장한 CollectionView
class OverlappingTouchCollectionView: UICollectionView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let initialHitView = super.hitTest(point, with: event)

        if initialHitView != self {
            for cell in self.visibleCells {
                if let photoCell = cell as? PhotoDisplayCell {
                    let pointInCell = self.convert(point, to: photoCell.contentView)
                    let buttonFrame = photoCell.deleteButton.frame
                    let expandedHitFrame = buttonFrame.insetBy(dx: -10, dy: -10)

                    if expandedHitFrame.contains(pointInCell) {
                        print("hitTest (CollectionView - Internal): Redirecting touch to removeButton!")
                        return photoCell.deleteButton
                    }
                }
            }
            return initialHitView
        }

        for cell in self.visibleCells {
            if let photoCell = cell as? PhotoDisplayCell {
                let pointInCell = self.convert(point, to: photoCell.contentView)
                let buttonFrame = photoCell.deleteButton.frame
                let expandedHitFrame = buttonFrame.insetBy(dx: -10, dy: -10)

                if expandedHitFrame.contains(pointInCell) {
                    return photoCell.deleteButton
                }
            }
        }

        return initialHitView
    }
}

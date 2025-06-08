//
//  ProgressbarView.swift
//  Mufe
//
//  Created by 신혜연 on 5/27/25.
//

import UIKit

import SnapKit
import Then

final class ProgressBarView: UIView {
    
    private let progressLayer = CALayer()
    
    var progress: CGFloat = 0 {
        didSet {
            updateProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        progressLayer.backgroundColor = UIColor.orange.cgColor
        layer.addSublayer(progressLayer)
    }
    
    private func updateProgress() {
        let width = bounds.width * progress
        progressLayer.frame = CGRect(x: 0, y: 0, width: width, height: bounds.height)
        
        let path = UIBezierPath(
            roundedRect: progressLayer.bounds,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: CGSize(width: 4, height: 4)
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        progressLayer.mask = mask
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateProgress()
    }
}

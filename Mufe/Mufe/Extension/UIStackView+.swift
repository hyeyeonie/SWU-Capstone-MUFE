//
//  UIStackView+.swift
//  Mufe
//
//  Created by 신혜연 on 8/30/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
}

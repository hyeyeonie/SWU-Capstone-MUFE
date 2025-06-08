//
//  UIVIew+.swift
//  Mufe
//
//  Created by 신혜연 on 6/8/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}

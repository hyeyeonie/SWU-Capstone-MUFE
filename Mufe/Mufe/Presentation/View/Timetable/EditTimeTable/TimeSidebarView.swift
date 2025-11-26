//
//  TimeSidebarView.swift
//  Mufe
//
//  Created by 신혜연 on 11/19/25.
//

import UIKit
import SnapKit
import Then

final class TimeSidebarView: UICollectionReusableView {
    
    static let identifier = "TimeSidebarView"
    
    private let containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = false
        containerStackView.clipsToBounds = false
        backgroundColor = .grayBg
        setLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setLayout() {
        addSubview(containerStackView)
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        for i in 0..<6 {
            let rowView = UIView()
            containerStackView.addArrangedSubview(rowView)
            rowView.snp.makeConstraints {
                $0.width.equalToSuperview()
            }
            
            if i == 0 {
                let label = UILabel().then {
                    $0.customFont(.fxs_Medium)
                    $0.textColor = .gray20
                    $0.textAlignment = .center
                    $0.tag = 100
                }
                rowView.addSubview(label)
                label.snp.makeConstraints {
                    $0.centerY.equalTo(rowView.snp.top)
                    $0.centerX.equalToSuperview()
                }
            } else if i == 3 {
                let label = UILabel().then {
                    $0.customFont(.fxs_Medium)
                    $0.textColor = .gray20
                    $0.textAlignment = .center
                    $0.tag = 200
                }
                rowView.addSubview(label)
                label.snp.makeConstraints {
                    $0.centerY.equalTo(rowView.snp.top)
                    $0.centerX.equalToSuperview()
                }
            } else {
                let line = UIView().then {
                    $0.backgroundColor = .gray50
                }
                rowView.addSubview(line)
                line.snp.makeConstraints {
                    $0.top.equalToSuperview()
                    $0.centerX.equalToSuperview()
                    $0.width.equalTo(8)
                    $0.height.equalTo(1)
                }
            }
        }
    }
    
    func configure(hour: Int) {
        if let row = containerStackView.arrangedSubviews.first,
           let label = row.viewWithTag(100) as? UILabel {
            label.text = "\(hour):00"
        }
        
        if let row = containerStackView.arrangedSubviews.dropFirst(3).first,
           let label = row.viewWithTag(200) as? UILabel {
            label.text = "\(hour):30"
        }
    }
}

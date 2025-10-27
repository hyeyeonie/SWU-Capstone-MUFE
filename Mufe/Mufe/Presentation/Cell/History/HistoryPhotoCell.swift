//
//  HistoryPhotoCell.swift
//  Mufe
//
//  Created by 신혜연 on 10/19/25.
//

import UIKit

import SnapKit
import Then

final class HistoryPhotoCell: UICollectionViewCell {
    
    static let identifier = "HistoryPhotoCell"
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray70
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadImageFromFileSystem(fileName: String) -> UIImage? {
        let fileManager = FileManager.default
        
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("🚨 Documents 디렉토리 경로 가져오기 실패")
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("⚠️ HistoryPhotoCell: 이미지 로드 실패 (\(fileName)): \(error)")
            return nil
        }
    }

    func configure(imageName: String) {
        imageView.backgroundColor = .gray70
        
        if let image = loadImageFromFileSystem(fileName: imageName) {
            imageView.image = image
            imageView.backgroundColor = .clear
        } else {
            imageView.image = nil
            print("🚨 이미지를 로드하지 못했습니다: \(imageName)")
        }
    }
}

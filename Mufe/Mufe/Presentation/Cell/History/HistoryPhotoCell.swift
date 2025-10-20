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
        $0.backgroundColor = .gray70 // 임시
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
        
        // 1. Documents 디렉토리 경로를 가져옵니다.
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("🚨 Documents 디렉토리 경로 가져오기 실패")
            return nil
        }
        
        // 2. 파일 URL을 만듭니다.
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // 3. 파일에서 데이터를 읽어와 UIImage를 생성합니다.
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("⚠️ HistoryPhotoCell: 이미지 로드 실패 (\(fileName)): \(error)")
            return nil
        }
    }

    func configure(imageName: String) {
        // 1. 이미지를 로드하기 전 임시 배경색을 다시 설정 (로딩 중 시각적 피드백)
        imageView.backgroundColor = .gray70
        
        // 2. 파일 시스템에서 이미지 로드
        if let image = loadImageFromFileSystem(fileName: imageName) {
            imageView.image = image
            imageView.backgroundColor = .clear // 이미지 로드 성공 시 배경색 제거
        } else {
            // 로드 실패 시에도 배경색 유지 (회색 네모)
            imageView.image = nil
            print("🚨 이미지를 로드하지 못했습니다: \(imageName)")
        }
    }
}

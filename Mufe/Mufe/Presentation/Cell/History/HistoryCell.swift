//
//  HistoryCell.swift
//  Mufe
//
//  Created by 신혜연 on 10/19/25.
//

import UIKit

import SnapKit
import Then

struct Memory {
    let text: String
    let photoNames: [String] // 이미지 이름 또는 URL 배열
}

final class HistoryCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "HistoryCell"
    
    var didTapAddMemory: (() -> Void)?
    var didTapMoreOptions: ((UIButton) -> Void)?
    private var photoNames: [String] = []
    
    // MARK: - UI Components
    
    private let artistImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .gray50
    }
    
    private let artistNameLabel = UILabel().then {
        $0.customFont(.flg_Bold)
        $0.textColor = .gray05
        $0.text = "아티스트 이름"
    }
    
    // --- 1. Empty State UI ---
    private let emptyLabel = UILabel().then {
        $0.text = "추억 남기기.."
        $0.customFont(.fmd_Regular)
        $0.textColor = .gray50
    }
    
    private lazy var addButton = UIButton(type: .system).then {
        let image = UIImage(systemName: "plus")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))
        $0.setImage(image, for: .normal)
        $0.tintColor = .gray50
        $0.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    // --- 2. Filled State UI ---
    private lazy var moreButton = UIButton(type: .system).then {
        let image = UIImage(systemName: "ellipsis")
        $0.setImage(image, for: .normal)
        $0.tintColor = .gray50
        $0.transform = CGAffineTransform(rotationAngle: .pi / 2)
        $0.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
    
    private let memoryLabel = UILabel().then {
        $0.text = "한로로의 공연은 잔잔하면서도 깊은 울림이... (추억 내용)"
        $0.customFont(.fmd_Regular)
        $0.textColor = .gray20
        $0.numberOfLines = 0
    }
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.register(HistoryPhotoCell.self, forCellWithReuseIdentifier: HistoryPhotoCell.identifier)
        return cv
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        contentView.backgroundColor = .gray90
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
    }
    
    private func setUI() {
        contentView.addSubviews(
            artistImage, artistNameLabel,
            emptyLabel, addButton,
            moreButton, memoryLabel, photoCollectionView
        )
    }
    
    private func setLayout() {
        
        // --- 공통 UI 레이아웃 ---
        artistImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.size.equalTo(40)
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(artistImage)
            $0.leading.equalTo(artistImage.snp.trailing).offset(12)
        }
    }
    
    func configure(artist: ArtistSchedule, memory: Memory?) {
            
            // 1. 공통 UI 설정
            artistImage.image = UIImage(named: artist.image)
            artistNameLabel.text = artist.name
            
            // 2. 동적 상태 분기
            if let memory = memory {
                // MARK: Filled State
                emptyLabel.isHidden = true
                addButton.isHidden = true
                
                moreButton.isHidden = false
                memoryLabel.isHidden = false
                
                memoryLabel.text = memory.text
                self.photoNames = memory.photoNames
                photoCollectionView.reloadData()
                photoCollectionView.isHidden = photoNames.isEmpty
                
                // --- 'Filled' 레이아웃 재설정 ---
                
                // 1. moreButton 레이아웃 (artistNameLabel이 참조해야 하므로 먼저)
                moreButton.snp.remakeConstraints {
                    $0.centerY.equalTo(artistImage)
                    $0.trailing.equalToSuperview().inset(16)
                    $0.size.equalTo(24)
                }
                
                // 2. artistNameLabel (moreButton 참조)
                artistNameLabel.snp.remakeConstraints {
                    $0.centerY.equalTo(artistImage)
                    $0.leading.equalTo(artistImage.snp.trailing).offset(12)
                    $0.trailing.lessThanOrEqualTo(moreButton.snp.leading).offset(-12)
                }
                
                if photoNames.isEmpty {
                    // 3. 사진 없음 (텍스트가 바닥)
                    memoryLabel.snp.remakeConstraints {
                        $0.top.equalTo(artistImage.snp.bottom).offset(12)
                        $0.leading.trailing.equalToSuperview().inset(16)
                        $0.bottom.equalToSuperview().inset(16)
                    }
                    photoCollectionView.snp.removeConstraints()
                    
                } else {
                    // 4. 사진 있음 (사진뷰가 바닥)
                    memoryLabel.snp.remakeConstraints {
                        $0.top.equalTo(artistImage.snp.bottom).offset(12)
                        $0.leading.trailing.equalToSuperview().inset(16)
                    }
                    photoCollectionView.snp.remakeConstraints {
                        $0.top.equalTo(memoryLabel.snp.bottom).offset(12)
                        $0.leading.trailing.equalToSuperview().inset(16)
                        $0.height.equalTo(80).priority(.low)
                        $0.bottom.equalToSuperview().inset(16)
                    }
                }
                // 비활성화될 뷰들의 제약조건 제거 (셀 재사용 대비)
                emptyLabel.snp.removeConstraints()
                addButton.snp.removeConstraints()
                
            } else {
                // MARK: Empty State
                emptyLabel.isHidden = false
                addButton.isHidden = false
                
                moreButton.isHidden = true
                memoryLabel.isHidden = true
                photoCollectionView.isHidden = true
                
                // --- 'Empty' 레이아웃 재설정 ---
                
                // 1. addButton 레이아웃 (artistNameLabel이 참조해야 하므로 먼저)
                addButton.snp.remakeConstraints {
                     // ⭐️ centerY는 emptyLabel 기준으로 (사용자 코드 반영)
                    $0.trailing.equalToSuperview().inset(16)
                    $0.size.equalTo(20) // 사용자가 제공한 값
                }
                
                // 2. artistNameLabel (addButton 참조)
                artistNameLabel.snp.remakeConstraints {
                    $0.centerY.equalTo(artistImage)
                    $0.leading.equalTo(artistImage.snp.trailing).offset(12)
                    // ⭐️ trailing 제약조건 추가 (addButton과 겹치지 않게)
                    $0.trailing.lessThanOrEqualTo(addButton.snp.leading).offset(-12)
                }
                
                // 3. emptyLabel (바닥 제약조건 추가)
                emptyLabel.snp.remakeConstraints {
                    $0.top.equalTo(artistImage.snp.bottom).offset(12) // 사용자가 제공한 값
                    $0.leading.equalTo(artistImage) // 사용자가 제공한 값
                    $0.bottom.equalToSuperview().inset(16) // ⭐️ 바닥에 붙여서 여백 제거 (일관성)
                }
                // ⭐️ addButton의 centerY를 emptyLabel 기준으로 다시 설정
                addButton.snp.makeConstraints {
                     $0.centerY.equalTo(emptyLabel) // 사용자가 제공한 값
                }

                // 비활성화될 뷰들의 제약조건을 확실히 제거
                moreButton.snp.removeConstraints()
                memoryLabel.snp.removeConstraints()
                photoCollectionView.snp.removeConstraints()
            }
        }
    
    // MARK: - Actions
    
    @objc private func addButtonTapped() {
        didTapAddMemory?()
    }
    
    @objc private func moreButtonTapped(_ sender: UIButton) {
        didTapMoreOptions?(sender)
    }
}

extension HistoryCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryPhotoCell.identifier, for: indexPath) as? HistoryPhotoCell else {
            return UICollectionViewCell()
        }
        let photoName = photoNames[indexPath.item]
        cell.configure(imageName: photoName)
        return cell
    }
}

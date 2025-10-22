//
//  ArtistCell.swift
//  Mufe
//
//  Created by 신혜연 on 6/5/25.
//

import UIKit

protocol ArtistCellDelegate: AnyObject {
    func didToggleArtistSelection(name: String, isSelected: Bool)
}

final class ArtistCell: UICollectionViewCell {
    
    static let identifier = "ArtistCell"
    weak var delegate: ArtistCellDelegate?
    
    private var selectedArtistNames: Set<String> = []
    private var currentArtists: [ArtistSchedule] = []
    
    private let stageLabel = UILabel().then {
        $0.customFont(.flg_Bold)
        $0.textColor = .gray00
    }
    
    private let locationLabel = UILabel().then {
        $0.customFont(.flg_Medium)
        $0.textColor = .gray40
    }
    
    private let artistContainerView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .center
    }
    
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
        backgroundColor = .gray90
        layer.cornerRadius = 16
    }
    
    private func setUI() {
        contentView.addSubviews(stageLabel, locationLabel, artistContainerView)
    }
    
    private func setLayout() {
        stageLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        locationLabel.snp.makeConstraints {
            $0.centerY.equalTo(stageLabel)
            $0.leading.equalTo(stageLabel.snp.trailing).offset(8)
        }
        
        artistContainerView.snp.makeConstraints {
            $0.top.equalTo(stageLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(stage: String, location: String, artists: [ArtistSchedule]) {
        stageLabel.text = stage
        locationLabel.text = location
        currentArtists = artists
        
        artistContainerView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let chunkedArtists = stride(from: 0, to: artists.count, by: 3).map {
            Array(artists[$0..<min($0 + 3, artists.count)])
        }
        
        for row in chunkedArtists {
            let hStack = UIStackView().then {
                $0.axis = .horizontal
                $0.spacing = 26.5
                $0.distribution = .fillEqually
            }
            
            for artist in row {
                let container = UIView()
                container.snp.makeConstraints {
                    $0.width.equalTo(90)
                    $0.height.equalTo(109)
                }
                
                let button = UIButton().then {
                    let artistImage = UIImage(named: artist.image)
                    
                    $0.setImage(artistImage ?? UIImage(named: "artist_default"), for: .normal)
                    $0.imageView?.contentMode = .scaleAspectFill
                    $0.clipsToBounds = true
                    $0.layer.cornerRadius = 40
                    $0.backgroundColor = .lightGray
                    $0.layer.borderWidth = isSelectedArtist(artist.name) ? 2 : 0
                    $0.layer.borderColor = UIColor.primary50.cgColor
                    $0.layer.masksToBounds = true
                    $0.accessibilityIdentifier = artist.name
                }
                
                let checkBackgroundView = UIView().then {
                    $0.backgroundColor = .primary50
                    $0.layer.cornerRadius = 12
                    $0.clipsToBounds = true
                    $0.isHidden = !isSelectedArtist(artist.name)
                }
                
                let checkmark = UIImageView().then {
                    $0.image = UIImage(named: "check")
                    $0.tintColor = .gray00
                    $0.contentMode = .scaleAspectFit
                }
                
                let nameLabel = UILabel().then {
                    $0.text = artist.name
                    $0.customFont(.fsm_SemiBold)
                    $0.textColor = isSelectedArtist(artist.name) ? .primary50 : .gray00
                    $0.textAlignment = .center
                }
                
                checkBackgroundView.addSubview(checkmark)
                container.addSubviews(button, checkBackgroundView, nameLabel)
                button.addTarget(self, action: #selector(artistButtonTapped(_:)), for: .touchUpInside)
                
                button.snp.makeConstraints {
                    $0.centerX.equalToSuperview()
                    $0.size.equalTo(80)
                }
                
                checkBackgroundView.snp.makeConstraints {
                    $0.width.height.equalTo(24)
                    $0.top.equalTo(button.snp.top)
                    $0.right.equalTo(button.snp.right)
                }
                
                checkmark.snp.makeConstraints {
                    $0.center.equalToSuperview()
                    $0.height.equalTo(12)
                    $0.width.equalTo(10)
                }
                
                nameLabel.snp.makeConstraints {
                    $0.top.equalTo(button.snp.bottom).offset(8)
                    $0.left.right.equalToSuperview()
                }
                
                hStack.addArrangedSubview(container)
            }
            artistContainerView.addArrangedSubview(hStack)
        }
    }
    
    @objc private func artistButtonTapped(_ sender: UIButton) {
        guard let artistName = sender.accessibilityIdentifier else { return }
        
        let isNowSelected: Bool
        if selectedArtistNames.contains(artistName) {
            selectedArtistNames.remove(artistName)
            isNowSelected = false
        } else {
            selectedArtistNames.insert(artistName)
            isNowSelected = true
        }
        
        delegate?.didToggleArtistSelection(name: artistName, isSelected: isNowSelected)

        configure(
            stage: stageLabel.text ?? "",
            location: locationLabel.text ?? "",
            artists: currentArtists
        )
    }
    
    private func isSelectedArtist(_ name: String) -> Bool {
        return selectedArtistNames.contains(name)
    }
}

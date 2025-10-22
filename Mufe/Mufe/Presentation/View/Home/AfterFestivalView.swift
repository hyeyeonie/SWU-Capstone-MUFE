//
//  AfterFestivalView.swift
//  Mufe
//
//  Created by 신혜연 on 8/30/25.
//

import UIKit

import SnapKit
import Then

protocol AfterFestivalViewDelegate: AnyObject {
    func didTapLaterButton()
    func didTapCreateMemoryButton()
}

final class AfterFestivalView: UIView {
    
    weak var delegate: AfterFestivalViewDelegate?
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .gray20
    }
    
    private let componentView = UIView().then {
        $0.backgroundColor = .gray90
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
    }
    
    private let posterImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(resource: .beautifulMintLife)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }
    
    private let dDayContainerView = UIView().then {
        $0.backgroundColor = .primary50
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    private let dDayLabel = UILabel().then {
        $0.customFont(.fsm_SemiBold)
        $0.text = "D-29"
        $0.textColor = .gray00
    }
    
    private let festivalNameLabel = UILabel().then {
        $0.text = "사운드 플래닛 페스티벌 2025"
        $0.numberOfLines = 2
        $0.textColor = .gray00
        $0.customFont(.flg_Bold)
    }
    
    private let festivalTime = UILabel().then {
        $0.text = "2025.09.13 - 2025.09.14"
        $0.textColor = .gray50
        $0.customFont(.fsm_Medium)
    }
    
    private let festivalLocation = UILabel().then {
        $0.text = "파라다이스 시티"
        $0.textColor = .gray50
        $0.customFont(.fsm_Medium)
    }
    
    private lazy var festivalInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [festivalNameLabel, festivalTime, festivalLocation])
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private let ticketLine = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ticketLine2")
    }
    
    private lazy var artistStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        return stackView
    }()
    
    private let buttonBackgroundView = UIImageView().then {
        $0.image = UIImage(named: "buttonBackground")
        $0.isUserInteractionEnabled = true
    }
    
    private let leftButton = UIButton().then {
        $0.setTitle("다음에 하기", for: .normal)
        $0.setTitleColor(.gray60, for: .normal)
        $0.titleLabel?.customFont(.flg_SemiBold)
        $0.backgroundColor = .gray90
        $0.layer.cornerRadius = 16
    }
    
    private let rightButton = UIButton().then {
        $0.setTitle("추억 남기기", for: .normal)
        $0.setTitleColor(.gray00, for: .normal)
        $0.titleLabel?.customFont(.flg_SemiBold)
        $0.backgroundColor = .primary50
        $0.layer.cornerRadius = 16
    }
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [leftButton, rightButton]).then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .grayBg
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setUI() {
        addSubviews(scrollView, buttonBackgroundView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, componentView)
        
        dDayContainerView.addSubview(dDayLabel)
        componentView.addSubviews(posterImage, dDayContainerView,
                                  festivalInfoStackView, ticketLine,
                                  artistStackView)
        buttonBackgroundView.addSubview(buttonStackView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(74)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        componentView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(113)
        }
        
        posterImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(140)
            $0.width.equalTo(105)
        }
        
        dDayContainerView.snp.makeConstraints {
            $0.top.equalTo(posterImage)
            $0.leading.equalTo(posterImage.snp.trailing).offset(12)
        }
        
        dDayLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        
        festivalInfoStackView.snp.makeConstraints {
            $0.top.equalTo(dDayContainerView.snp.bottom).offset(10)
            $0.leading.equalTo(dDayContainerView)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        ticketLine.snp.makeConstraints{
            $0.top.equalTo(posterImage.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        artistStackView.snp.makeConstraints {
            $0.top.equalTo(ticketLine.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        buttonBackgroundView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(101)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func setDelegate() {
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    func setFestival(_ festival: SavedFestival) {
        let fullText = "\(festival.festivalName) 의\n후기를 작성해 보세요!"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let baseFont = CustomUIFont.fxl_Medium.font
        let boldFont = CustomUIFont.fxl_Bold.font
        
        let lineSpacing = CustomUIFont.fxl_Medium.lineSpacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        attributedString.addAttribute(.font, value: baseFont, range: NSRange(location: 0, length: fullText.count))
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: fullText.count))
        
        if let range = fullText.range(of: festival.festivalName) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.font, value: boldFont, range: nsRange)
        }
        titleLabel.attributedText = attributedString
        posterImage.image = UIImage(named: festival.festivalImageName)
        dDayLabel.text = "종료"
        festivalNameLabel.text = festival.festivalName
        festivalTime.text = "\(festival.startDate) - \(festival.endDate)"
        festivalLocation.text = festival.location
        
        artistStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let artists = festival.timetables.prefix(5)
        
        artists.forEach { timetable in
            let artistView = createArtistContainer(image: UIImage(named: timetable.artistImage) ?? UIImage(), name: timetable.artistName)
            artistStackView.addArrangedSubview(artistView)
        }
    }
    
    @objc private func leftButtonTapped() {
        print("다음에 하기")
        delegate?.didTapLaterButton()
    }
    
    @objc private func rightButtonTapped() {
        print("추억 남기기")
        delegate?.didTapCreateMemoryButton()
    }
    
    private func createArtistContainer(image: UIImage, name: String) -> UIStackView {
        let imageView = UIImageView().then {
            $0.image = image
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.snp.makeConstraints { $0.size.equalTo(40) }
        }
        
        let nameLabel = UILabel().then {
            $0.text = name
            $0.textColor = .gray00
            $0.customFont(.flg_Bold)
        }
        
        let container = UIStackView(arrangedSubviews: [imageView, nameLabel])
        container.axis = .horizontal
        container.spacing = 12
        container.alignment = .center
        
        return container
    }
}

#Preview {
    AfterFestivalView()
}

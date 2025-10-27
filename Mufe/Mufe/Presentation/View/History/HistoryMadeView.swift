//
//  HistoryMadeView.swift
//  Mufe
//
//  Created by 신혜연 on 10/19/25.
//

import UIKit

import SnapKit
import Then

protocol HistoryMadeViewDelegate: AnyObject {
    func didTapCloseButton()
    func didTapDoneButton(reviewText: String, photos: [UIImage])
    func didTapAddPhotoButton()
    func didTapRemovePhotoButton(at index: Int)
}

final class HistoryMadeView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: HistoryMadeViewDelegate?
    
    private var photos: [UIImage] = []
    let maxPhotoCount = 5
    private let maxCharacterCount = 400
    private let placeholderText = "공연은 어떠셨나요? 감상을 남겨보세요."
    private var reviewTextViewHeightConstraint: Constraint?
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "추억 남기기"
        $0.customFont(.flg_SemiBold)
        $0.textColor = .gray00
    }
    
    private lazy var closeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .gray05
        $0.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private let artistImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 32
        $0.backgroundColor = .gray50
    }
    
    private let artistNameLabel = UILabel().then {
        $0.customFont(.f2xl_Bold)
        $0.textColor = .gray00
        $0.text = "아티스트 이름"
    }
    
    private let reviewContainerView = UIView().then {
        $0.backgroundColor = .gray90
        $0.layer.cornerRadius = 16
    }
    
    private let reviewTitleLabel = UILabel().then {
        $0.text = "감상평"
        $0.customFont(.flg_Bold)
        $0.textColor = .gray00
        $0.textAlignment = .left
    }
    
    private lazy var reviewTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.textColor = .gray50
        $0.customFont(.fmd_Regular)
        $0.text = placeholderText
    }
    
    private let characterCountLabel = UILabel().then {
        $0.text = "0 / 400"
        $0.customFont(.fmd_Regular)
        $0.textColor = .gray50
        $0.textAlignment = .right
    }
    
    // --- Photo Section ---
    private let photoContainerView = UIView().then {
        $0.backgroundColor = .gray90
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    private let photoTitleLabel = UILabel().then {
        $0.text = "사진"
        $0.customFont(.flg_Bold)
        $0.textColor = .gray00
    }
    
    private lazy var photoCollectionView: OverlappingTouchCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        
        let cv = OverlappingTouchCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(PhotoAddCell.self, forCellWithReuseIdentifier: PhotoAddCell.identifier)
        cv.register(PhotoDisplayCell.self, forCellWithReuseIdentifier: PhotoDisplayCell.identifier)
        cv.clipsToBounds = false
        return cv
    }()
    
    // --- Bottom Button ---
    private lazy var doneButton = UIButton(type: .system).then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = CustomUIFont.fmd_Bold.font

        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let image = UIImage(systemName: "checkmark", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = .gray50
        
        $0.setTitleColor(.gray50, for: .normal)
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true

        $0.semanticContentAttribute = .forceRightToLeft
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
        setDelegate()
        setAction()
        setupInitialTextViewHeight()
        updateDoneButtonState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialTextViewHeight() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let size = CGSize(width: self.reviewTextView.frame.width, height: .infinity)
            let estimatedSize = self.reviewTextView.sizeThatFits(size)
            let clampedHeight = min(max(estimatedSize.height, 26), 150)
            self.reviewTextViewHeightConstraint?.update(offset: clampedHeight)
        }
    }
    
    private func setStyle() {
        backgroundColor = .grayBg
    }
    
    private func setUI() {
        addSubviews(titleLabel, closeButton, artistImage, artistNameLabel,
                    reviewContainerView, photoContainerView, doneButton)
        
        reviewContainerView.addSubviews(reviewTitleLabel, reviewTextView, characterCountLabel)
        photoContainerView.addSubviews(photoTitleLabel, photoCollectionView)
    }
    
    private func setLayout() {
        // --- Top Bar ---
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.centerX.equalToSuperview()
        }
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
        
        // --- Artist Info ---
        artistImage.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(64)
        }
        artistNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(artistImage)
            $0.leading.equalTo(artistImage.snp.trailing).offset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        // --- Review Section ---
        reviewContainerView.snp.makeConstraints {
            $0.top.equalTo(artistImage.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        reviewTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        reviewTextView.snp.makeConstraints {
            $0.top.equalTo(reviewTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            reviewTextViewHeightConstraint = $0.height.equalTo(26).constraint
        }
        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(reviewTextView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        // --- Photo Section ---
        photoContainerView.snp.makeConstraints {
            $0.top.equalTo(reviewContainerView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        photoTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        photoCollectionView.snp.makeConstraints {
            $0.top.equalTo(photoTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(80)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        // --- Bottom Button ---
        doneButton.snp.makeConstraints {
            $0.top.equalTo(photoContainerView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(42)
            $0.width.equalTo(72)
        }
    }
    
    private func setAction() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func setDelegate() {
        reviewTextView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(reviewContainerTapped))
        tapGesture.cancelsTouchesInView = false
        reviewContainerView.addGestureRecognizer(tapGesture)
        reviewContainerView.isUserInteractionEnabled = true
    }
    
    @objc private func reviewContainerTapped() {
        reviewTextView.becomeFirstResponder()
    }
    
    func configure(artistName: String, artistImageName: String) {
        artistNameLabel.text = artistName
        artistImage.image = UIImage(named: artistImageName)
    }
    
    func setInitialText(_ text: String) {
        if !text.isEmpty {
            reviewTextView.text = text
            reviewTextView.textColor = .gray20
            updateCharacterCountLabel()
            updateDoneButtonState()
        }
    }
    
    func updatePhotos(_ newPhotos: [UIImage]) {
        self.photos = Array(newPhotos.prefix(maxPhotoCount))
        self.photoCollectionView.reloadData()
        updateDoneButtonState()
    }
    
    @objc private func closeButtonTapped() {
        delegate?.didTapCloseButton()
    }
    
    @objc private func doneButtonTapped() {
        guard let text = reviewTextView.text, text != placeholderText else {
            delegate?.didTapDoneButton(reviewText: "", photos: photos)
            return
        }
        delegate?.didTapDoneButton(reviewText: text, photos: photos)
    }
    
    private func updateDoneButtonState() {
        let text = reviewTextView.text ?? ""
        let hasText = !text.isEmpty && text != placeholderText
        let isEnabled = hasText || !photos.isEmpty
        
        doneButton.isEnabled = isEnabled
        doneButton.backgroundColor = isEnabled ? .primary50 : .gray90
        doneButton.setTitleColor(isEnabled ? .gray00 : .gray50, for: .normal)
        doneButton.tintColor = isEnabled ? .gray00 : .gray50
    }
    
    private func updateCharacterCountLabel() {
        let currentCount = reviewTextView.text.count
        let maxCount = maxCharacterCount

        let countString = "\(currentCount) / \(maxCount)"
        let attributedString = NSMutableAttributedString(string: countString)
        
        let numberRange = (countString as NSString).range(of: "\(currentCount)")
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray30, range: numberRange)
        
        let maxRange = (countString as NSString).range(of: " / \(maxCount)")
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray50, range: maxRange)
        
        if currentCount > maxCount {
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: NSRange(location: 0, length: countString.count))
        }
        
        characterCountLabel.attributedText = attributedString
    }
}

extension HistoryMadeView: UITextViewDelegate {
    // 편집 시작 시
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .gray20
        }
    }
    
    // 편집 종료 시
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .gray50
        }
    }

    // 텍스트 변경 시
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != placeholderText {
            updateTextViewHeight()
        }
        updateCharacterCountLabel()
        updateDoneButtonState()
        
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .gray50
            textView.resignFirstResponder()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= maxCharacterCount
    }
    
    private func updateTextViewHeight() {
        let size = CGSize(width: reviewTextView.frame.width, height: .infinity)
        let estimatedSize = reviewTextView.sizeThatFits(size)
        let clampedHeight = min(max(estimatedSize.height, 26), 150)
        
        reviewTextViewHeightConstraint?.update(offset: clampedHeight)
        UIView.animate(withDuration: 0.15) {
            self.layoutIfNeeded()
        }
    }
}


// MARK: - UICollectionViewDataSource & Delegate (사진 컬렉션 뷰)
extension HistoryMadeView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoAddCell.identifier, for: indexPath) as? PhotoAddCell else {
                fatalError("PhotoAddCell dequeue 실패")
            }
            let countText = "\(photos.count)/\(maxPhotoCount)"
            cell.configure(countText: countText)
            cell.isAddEnabled = photos.count < maxPhotoCount
            cell.didTapAdd = { [weak self] in
                self?.delegate?.didTapAddPhotoButton()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoDisplayCell.identifier, for: indexPath) as? PhotoDisplayCell else {
                fatalError("PhotoDisplayCell dequeue 실패")
            }
            let photoIndex = indexPath.item - 1
            cell.configure(image: photos[photoIndex])
            cell.didTapRemove = { [weak self] in
                self?.delegate?.didTapRemovePhotoButton(at: photoIndex)
            }
            return cell
        }
    }
}

#Preview {
    HistoryMadeView()
}

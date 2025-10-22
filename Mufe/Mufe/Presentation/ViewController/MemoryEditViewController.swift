//
//  MemoryEditViewController.swift
//  Mufe
//
//  Created by 신혜연 on 10/20/25.
//

import UIKit
import SwiftData

import SnapKit
import Then
import PhotosUI

protocol MemoryEditDelegate: AnyObject {
    func memoryDidSave(for artistName: String, dayKey: String) // 저장 완료 알림
}

class MemoryEditViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: MemoryEditDelegate?
    
    var artist: ArtistSchedule?
    var dayKey: String?
    var savedFestivalId: String?
    var existingMemory: ArtistMemory?
    private var currentPhotos: [UIImage] = []
    private var modelContext: ModelContext? {
        return SwiftDataManager.shared.context
    }
    private var targetSavedTimetable: SavedTimetable?
    
    // MARK: - UI Components
    
    private let historyMadeView = HistoryMadeView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = historyMadeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        configureInitialData()
        setupKeyboardDismiss()
    }
    
    // MARK: - Setup Methods
    
    private func setDelegate() {
        historyMadeView.delegate = self
    }
    
    private func configureInitialData() {
        guard let artist = artist, let _ = dayKey, let festivalId = savedFestivalId else {
            print("🚨 MemoryEditVC: Artist, DayKey 또는 Festival ID 정보가 전달되지 않았습니다.")
            dismissOrPopViewController()
            return
        }
        
        historyMadeView.configure(artistName: artist.name, artistImageName: artist.image)
        findTargetSavedTimetable(artistName: artist.name, festivalId: festivalId)
        
        if let memory = existingMemory {
            historyMadeView.setInitialText(memory.reviewText)
            self.currentPhotos = loadImagesFromFileSystem(identifiers: memory.photoIdentifiers)
            historyMadeView.updatePhotos(self.currentPhotos)
        }
    }
    
    private func findTargetSavedTimetable(artistName: String, festivalId: String) {
        guard let context = modelContext else { return }
        
        let timetablePredicate = #Predicate<SavedTimetable> {
            $0.artistName == artistName && $0.savedFestival?.id == festivalId
        }
        let descriptor = FetchDescriptor(predicate: timetablePredicate)
        
        do {
            let results = try context.fetch(descriptor)
            if let timetable = results.first {
                self.targetSavedTimetable = timetable
                print("Target SavedTimetable 찾음: \(timetable.artistName)")
                if self.existingMemory == nil {
                    self.existingMemory = timetable.memory
                }
            } else {
                print("🚨 findTargetSavedTimetable: \(artistName) (\(festivalId)) 에 해당하는 SavedTimetable 없음.")
            }
        } catch {
            print("🚨 findTargetSavedTimetable Fetch 실패: \(error)")
        }
    }
    
    private func saveImagesToFileSystem(_ images: [UIImage]) -> [String] {
        var identifiers: [String] = []
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("🚨 Documents 디렉토리 경로 가져오기 실패")
            return []
        }
        
        for image in images {
            let fileName = UUID().uuidString + ".jpg"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            // UIImage를 JPEG 데이터로 변환 (압축 품질 조절 가능 0.0 ~ 1.0)
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                do {
                    // 파일 쓰기
                    try imageData.write(to: fileURL)
                    identifiers.append(fileName)
                    print("🖼️ 이미지 저장 성공: \(fileName)")
                } catch {
                    print("🚨 이미지 파일 쓰기 실패 (\(fileName)): \(error)")
                }
            } else {
                print("🚨 UIImage -> JPEG 데이터 변환 실패")
            }
        }
        // TODO: 기존 이미지 중 삭제된 이미지를 파일 시스템에서도 삭제하는 로직 추가 필요
        return identifiers
    }
    
    private func loadImagesFromFileSystem(identifiers: [String]) -> [UIImage] {
        var loadedImages: [UIImage] = []
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
        
        for identifier in identifiers {
            let fileURL = documentsDirectory.appendingPathComponent(identifier)
            if let imageData = try? Data(contentsOf: fileURL), let image = UIImage(data: imageData) {
                loadedImages.append(image)
            } else {
                print("⚠️ 이미지 로드 실패: \(identifier)")
            }
        }
        return loadedImages
    }
    
    // MARK: - Helper
    
    private func dismissOrPopViewController(animated: Bool = true) {
        if let navController = navigationController, navController.viewControllers.first != self {
            navController.popViewController(animated: animated)
        } else {
            dismiss(animated: animated)
        }
    }
    
    private func checkPhotoPermissionAndPresentPicker() {
        let requiredAccessLevel: PHAccessLevel = .readWrite
        PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("✅ Photo Library Access: Authorized")
                    self?.presentImagePicker()
                case .limited:
                    print("⚠️ Photo Library Access: Limited")
                    self?.presentImagePicker()
                case .denied, .restricted:
                    print("❌ Photo Library Access: Denied or Restricted")
                    self?.showPermissionAlert()
                case .notDetermined:
                    print("Photo Library Access: Not Determined (Should not happen here)")
                @unknown default:
                    fatalError("Unknown photo library authorization status")
                }
            }
        }
    }
    
    private func presentImagePicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = historyMadeView.maxPhotoCount - currentPhotos.count
        config.preferredAssetRepresentationMode = .current
        config.selection = .ordered
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "사진 접근 권한 필요",
            message: "추억에 사진을 추가하려면 사진첩 접근 권한이 필요합니다. 설정 앱에서 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(settingsUrl) else { return }
            UIApplication.shared.open(settingsUrl)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MemoryEditViewController: HistoryMadeViewDelegate {
    
    func didTapCloseButton() {
        print("닫기 버튼 탭됨")
        dismissOrPopViewController()
    }
    
    func didTapDoneButton(reviewText: String, photos: [UIImage]) {
        print("DEBUG: 1. doneButton 함수 시작")
        
        guard let context = modelContext else {
            print("🚨 저장 실패: ModelContext 없음")
            return
        }
        print("DEBUG: 2. ModelContext 확인 완료")
        
        guard let targetTimetable = targetSavedTimetable else {
            print("🚨 저장 실패: 대상 SavedTimetable 없음")
            // 사용자에게 알림 등
            return
        }
        print("DEBUG: 3. Target SavedTimetable 확인 완료")
        
        guard let currentArtist = artist, let currentDayKey = dayKey else {
            print("🚨 저장 실패: 아티스트 또는 날짜 정보 부족")
            return
        }
        print("DEBUG: 4. 모든 필수 데이터 확인 완료. 저장 시도.")
        
        let photoIdentifiers = saveImagesToFileSystem(photos)
        
        let memoryToSave: ArtistMemory
        if let existing = targetTimetable.memory {
            // ----- 수정 -----
            print("✏️ 기존 추억 업데이트")
            memoryToSave = existing
            memoryToSave.reviewText = reviewText
            memoryToSave.photoIdentifiers = photoIdentifiers
        } else {
            // ----- 새로 생성 -----
            print("✨ 새 추억 생성")
            memoryToSave = ArtistMemory(savedTimetable: targetTimetable, reviewText: reviewText, photoIdentifiers: photoIdentifiers)
            context.insert(memoryToSave)
            targetTimetable.memory = memoryToSave
        }
        
        do {
            try context.save()
            print("✅ 추억 저장 성공!")
            delegate?.memoryDidSave(for: currentArtist.name, dayKey: currentDayKey)
            dismissOrPopViewController()
        } catch {
            print("🚨 추억 저장 실패: \(error)")
        }
    }
    
    func didTapAddPhotoButton() {
        print("사진 추가 버튼 탭됨")
        checkPhotoPermissionAndPresentPicker()
    }
    
    func didTapRemovePhotoButton(at index: Int) {
        print("\(index)번째 사진 삭제 버튼 탭됨")
        if index < currentPhotos.count {
            currentPhotos.remove(at: index)
            historyMadeView.updatePhotos(currentPhotos)
        }
    }
}

extension MemoryEditViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else { return }

        let group = DispatchGroup()
        var newlySelectedPhotos: [UIImage] = []

        for result in results {
            group.enter()
            let provider = result.itemProvider
            if provider.canLoadObject(ofClass: UIImage.self) {
                // 이미지 비동기 로드
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    defer { group.leave() }
                    if let image = image as? UIImage {
                        newlySelectedPhotos.append(image)
                    } else if let error = error {
                        print("🚨 이미지 로드 실패: \(error)")
                    }
                }
            } else {
                 print("⚠️ 로드할 수 없는 타입의 asset입니다.")
                 group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            print("✅ \(newlySelectedPhotos.count)개 이미지 로드 완료")
            self.currentPhotos.append(contentsOf: newlySelectedPhotos)
            self.historyMadeView.updatePhotos(self.currentPhotos)
        }
    }
}

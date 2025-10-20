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
    
    // HistoryDetailViewController로부터 전달받을 데이터
    var artist: ArtistSchedule?
    var dayKey: String? // "1일차" 등 (저장 시 필요)
    var savedFestivalId: String?
    var existingMemory: ArtistMemory? // 수정 모드일 경우 기존 데이터
    private var currentPhotos: [UIImage] = []
    private var modelContext: ModelContext? {
        return SwiftDataManager.shared.context
    }
    private var targetSavedTimetable: SavedTimetable?
    
    // MARK: - UI Components
    
    // 사용할 메인 뷰
    private let historyMadeView = HistoryMadeView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        // 뷰 컨트롤러의 기본 view를 historyMadeView로 설정
        self.view = historyMadeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setDelegate()
        configureInitialData()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        // HistoryMadeView에 필요한 초기 설정 (ViewController 레벨에서)
        // 예: 배경색 등 (HistoryMadeView 자체에서 이미 설정되어 있다면 불필요)
    }
    
    private func setDelegate() {
        historyMadeView.delegate = self // HistoryMadeView의 delegate를 self로 설정
    }
    
    /// 전달받은 데이터로 View를 초기 설정합니다.
    private func configureInitialData() {
        guard let artist = artist, let dayKey = dayKey, let festivalId = savedFestivalId else {
            print("🚨 MemoryEditVC: Artist, DayKey 또는 Festival ID 정보가 전달되지 않았습니다.")
            dismissOrPopViewController()
            return
        }
        historyMadeView.configure(artistName: artist.name, artistImageName: artist.image)
        
        // ⭐️⭐️⭐️ 수정/생성 대상 SavedTimetable 찾기 ⭐️⭐️⭐️
        findTargetSavedTimetable(artistName: artist.name, festivalId: festivalId)
        
        // 수정 모드일 경우 기존 데이터 로드
        if let memory = existingMemory {
            historyMadeView.setInitialText(memory.reviewText) // ⭐️ View에 텍스트 설정 함수 추가 필요
            self.currentPhotos = loadImagesFromFileSystem(identifiers: memory.photoIdentifiers) // ⭐️ 이미지 로드 함수 구현 필요
            historyMadeView.updatePhotos(self.currentPhotos)
        }
    }
    
    private func findTargetSavedTimetable(artistName: String, festivalId: String) {
        guard let context = modelContext else { return }
        
        // Predicate를 사용하여 SavedTimetable 필터링
        let timetablePredicate = #Predicate<SavedTimetable> {
            $0.artistName == artistName && $0.savedFestival?.id == festivalId
        }
        let descriptor = FetchDescriptor(predicate: timetablePredicate)
        
        do {
            let results = try context.fetch(descriptor)
            if let timetable = results.first {
                self.targetSavedTimetable = timetable
                print("✅ Target SavedTimetable 찾음: \(timetable.artistName)")
                // 기존 메모리 로드를 위해 existingMemory도 업데이트 (수정 시)
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
        // 앱의 Documents 디렉토리 경로 가져오기
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("🚨 Documents 디렉토리 경로 가져오기 실패")
            return []
        }
        
        for image in images {
            let fileName = UUID().uuidString + ".jpg" // 고유 파일 이름 생성 (JPEG 형식)
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            // UIImage를 JPEG 데이터로 변환 (압축 품질 조절 가능 0.0 ~ 1.0)
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                do {
                    // 파일 쓰기
                    try imageData.write(to: fileURL)
                    identifiers.append(fileName) // 성공 시 식별자(파일 이름) 추가
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
    
    /// 현재 뷰 컨트롤러를 닫습니다 (Present/Push 방식에 따라).
    private func dismissOrPopViewController(animated: Bool = true) {
        if let navController = navigationController, navController.viewControllers.first != self {
            navController.popViewController(animated: animated)
        } else {
            dismiss(animated: animated)
        }
    }
    
    private func checkPhotoPermissionAndPresentPicker() {
        let requiredAccessLevel: PHAccessLevel = .readWrite // 읽기/쓰기 권한 요청 (.addOnly도 가능)
        PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { [weak self] status in
            DispatchQueue.main.async { // UI 관련 작업은 메인 스레드에서
                switch status {
                case .authorized: // 모든 사진 접근 허용
                    print("✅ Photo Library Access: Authorized")
                    self?.presentImagePicker()
                case .limited: // 일부 사진만 접근 허용
                    print("⚠️ Photo Library Access: Limited")
                    self?.presentImagePicker() // 제한된 상태에서도 피커는 띄울 수 있음
                case .denied, .restricted: // 접근 거부 또는 제한됨
                    print("❌ Photo Library Access: Denied or Restricted")
                    self?.showPermissionAlert() // 설정으로 유도하는 알림창 띄우기
                case .notDetermined: // 아직 권한 요청 안 함 (이 경우는 requestAuthorization 호출 시 처리됨)
                    print("Photo Library Access: Not Determined (Should not happen here)")
                @unknown default:
                    fatalError("Unknown photo library authorization status")
                }
            }
        }
    }
    
    private func presentImagePicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared()) // 기본 라이브러리 사용
        config.filter = .images // 이미지만 선택 가능하도록 필터링
        config.selectionLimit = historyMadeView.maxPhotoCount - currentPhotos.count // ⭐️ 남은 개수만큼만 선택 가능
        config.preferredAssetRepresentationMode = .current // 최적화된 방식으로 이미지 로드
        config.selection = .ordered // 선택 순서 유지 (필요하다면)
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self // 델리게이트 설정
        present(picker, animated: true)
    }
    
    /// 권한 거부 시 사용자에게 설정 앱으로 이동하도록 안내하는 알림창을 띄웁니다.
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "사진 접근 권한 필요",
            message: "추억에 사진을 추가하려면 사진첩 접근 권한이 필요합니다. 설정 앱에서 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            // 설정 앱의 내 앱 설정 화면으로 바로 이동
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(settingsUrl) else { return }
            UIApplication.shared.open(settingsUrl)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - HistoryMadeViewDelegate Implementation
extension MemoryEditViewController: HistoryMadeViewDelegate {
    
    func didTapCloseButton() {
        print("닫기 버튼 탭됨")
        // 화면 닫기 (Present로 띄웠다면 dismiss, Push로 띄웠다면 pop)
        dismissOrPopViewController()
    }
    
    func didTapDoneButton(reviewText: String, photos: [UIImage]) {
        print("DEBUG: 1. doneButton 함수 시작") // ⭐️ 추가
        
        guard let context = modelContext else {
            print("🚨 저장 실패: ModelContext 없음") // ⭐️ 이 로그가 찍히는지 확인
            return
        }
        print("DEBUG: 2. ModelContext 확인 완료") // ⭐️ 추가
        
        guard let targetTimetable = targetSavedTimetable else {
            print("🚨 저장 실패: 대상 SavedTimetable 없음") // ⭐️ 이 로그가 찍히는지 확인
            // 사용자에게 알림 등
            return
        }
        print("DEBUG: 3. Target SavedTimetable 확인 완료") // ⭐️ 추가
        
        guard let currentArtist = artist, let currentDayKey = dayKey else {
            print("🚨 저장 실패: 아티스트 또는 날짜 정보 부족") // ⭐️ 이 로그가 찍히는지 확인
            return
        }
        print("DEBUG: 4. 모든 필수 데이터 확인 완료. 저장 시도.") // ⭐️ 추가
        
        // 1. 이미지 파일 저장 및 식별자 배열 얻기
        let photoIdentifiers = saveImagesToFileSystem(photos)
        
        // 2. ArtistMemory 객체 찾기 또는 생성
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
            // ArtistMemory 생성 및 SavedTimetable과 연결
            memoryToSave = ArtistMemory(savedTimetable: targetTimetable, reviewText: reviewText, photoIdentifiers: photoIdentifiers)
            // ⭐️ 중요: 새로 생성된 ArtistMemory를 context에 insert
            context.insert(memoryToSave)
            // ⭐️ 중요: SavedTimetable의 memory 관계 업데이트 (SwiftData가 자동으로 처리해주기도 함)
            targetTimetable.memory = memoryToSave
        }
        
        // 3. SwiftData에 변경사항 저장 시도
        do {
            try context.save()
            print("✅ 추억 저장 성공!")
            // 저장 성공 후 화면 닫기
            delegate?.memoryDidSave(for: currentArtist.name, dayKey: currentDayKey)
            dismissOrPopViewController()
        } catch {
            print("🚨 추억 저장 실패: \(error)")
            // 사용자에게 저장 실패 알림 표시 (UIAlertController 등)
        }
    }
    
    func didTapAddPhotoButton() {
        print("사진 추가 버튼 탭됨")
        checkPhotoPermissionAndPresentPicker() // 권한 확인 및 피커 띄우기 함수 호출
    }
    
    func didTapRemovePhotoButton(at index: Int) {
        print("\(index)번째 사진 삭제 버튼 탭됨")
        // currentPhotos 배열에서 해당 인덱스 이미지 제거
        if index < currentPhotos.count {
            currentPhotos.remove(at: index)
            // historyMadeView 업데이트
            historyMadeView.updatePhotos(currentPhotos)
        }
    }
}

extension MemoryEditViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 피커 닫기
        picker.dismiss(animated: true)

        // 아무것도 선택하지 않았으면 종료
        guard !results.isEmpty else { return }

        // 로드할 이미지 개수를 추적하기 위한 DispatchGroup 생성
        let group = DispatchGroup()
        // 로드된 이미지를 임시로 저장할 배열 (순서 보장 어려울 수 있음)
        var newlySelectedPhotos: [UIImage] = []

        for result in results {
            group.enter() // 그룹 작업 시작 알림
            let provider = result.itemProvider
            // 이미지 로드 가능한지 확인
            if provider.canLoadObject(ofClass: UIImage.self) {
                // 이미지 비동기 로드
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    defer { group.leave() } // 작업 완료 알림 (성공/실패 무관)
                    if let image = image as? UIImage {
                        // 로드 성공 시 배열에 추가 (메인 스레드 불필요)
                        newlySelectedPhotos.append(image)
                    } else if let error = error {
                        print("🚨 이미지 로드 실패: \(error)")
                    }
                }
            } else {
                 print("⚠️ 로드할 수 없는 타입의 asset입니다.")
                 group.leave() // 로드할 수 없어도 그룹 작업 완료 처리
            }
        }

        // 모든 이미지 로드 작업이 완료된 후 실행될 코드
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            print("✅ \(newlySelectedPhotos.count)개 이미지 로드 완료")
            // 기존 사진 배열과 새로 선택된 사진 배열 합치기
            self.currentPhotos.append(contentsOf: newlySelectedPhotos)
            // historyMadeView 업데이트 (최대 개수 제한은 updatePhotos 내부에서 처리)
            self.historyMadeView.updatePhotos(self.currentPhotos)
        }
    }
}

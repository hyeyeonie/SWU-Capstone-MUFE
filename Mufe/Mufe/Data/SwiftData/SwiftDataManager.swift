//
//  SwiftDataManager.swift
//  Mufe
//
//  Created by 신혜연 on 10/15/25.
//

import Foundation
import SwiftData

final class SwiftDataManager {
    // ⭐️ 앱 전체에서 이 한 가지 인스턴스만 사용합니다. (싱글톤)
    static let shared = SwiftDataManager()

    // 데이터베이스 컨테이너와 실제 작업을 수행할 컨텍스트
    let container: ModelContainer
    let context: ModelContext

    private init() {
        do {
            // 1. 우리가 1단계에서 만든 모델 설계도를 바탕으로 데이터베이스 '컨테이너'를 만듭니다.
            let schema = Schema([SavedFestival.self, SavedTimetable.self])
            let config = ModelConfiguration()
            container = try ModelContainer(for: schema, configurations: config)

            // 2. 이 컨테이너에서 실제 데이터 작업을 할 '작업 공간(컨텍스트)'을 가져옵니다.
            context = ModelContext(container)
        } catch {
            fatalError("🚨 SwiftData 컨테이너 생성에 실패했습니다: \(error)")
        }
    }
}

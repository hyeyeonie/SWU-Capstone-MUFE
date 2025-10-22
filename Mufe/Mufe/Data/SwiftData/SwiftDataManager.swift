//
//  SwiftDataManager.swift
//  Mufe
//
//  Created by 신혜연 on 10/15/25.
//

import Foundation
import SwiftData

class SwiftDataManager {
    static let shared = SwiftDataManager()
    
    let container: ModelContainer
    var context: ModelContext
    
    private init() {
        do {
            self.container = try ModelContainer(for: SavedFestival.self)
            self.context = ModelContext(container)
        } catch {
            fatalError("SwiftData Container를 설정하지 못했습니다: \(error)")
        }
    }
    
    // MARK: - Save Operations
    
    func save<T: PersistentModel>(_ model: T) {
        context.insert(model)
        do {
            try context.save()
            print("✅ 데이터 저장 성공: \(T.self)")
        } catch {
            print("🚨 데이터 저장 실패: \(error)")
        }
    }
    
    // MARK: - Fetch Operations
    
    func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> [T] {
        return try context.fetch(descriptor)
    }
    
    // MARK: - Delete Operations
    
    func deleteSavedFestival(festivalName: String, day: String, completion: @escaping (Bool) -> Void) {
        do {
            let predicate = #Predicate<SavedFestival> { saved in
                saved.festivalName == festivalName && saved.selectedDay == day
            }
            var descriptor = FetchDescriptor<SavedFestival>(predicate: predicate)
            descriptor.fetchLimit = 1
            
            if let savedFestivalToDelete = try context.fetch(descriptor).first {
                context.delete(savedFestivalToDelete)
                try context.save()
                print("✅ SwiftData: \(festivalName) - \(day) 삭제 성공.")
                completion(true)
            } else {
                print("⚠️ SwiftData: \(festivalName) - \(day)를 찾을 수 없어 삭제하지 못했습니다.")
                completion(false)
            }
        } catch {
            print("🚨 SwiftData: 삭제 실패 - \(error)")
            completion(false)
        }
    }
}

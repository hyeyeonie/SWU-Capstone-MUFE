//
//  FestivalPromptBuilder.swift
//  Mufe
//
//  Created by 신혜연 on 6/14/25.
//

import Foundation

struct FestivalPromptBuilder {
    struct ArtistForPrompt: Codable {
        let artistName: String
        let imageName: String
        let location: String
        let startTime: String
        let endTime: String
        let runningTime: Int
    }
    
    static func createPrompt(preference: Preference, festivalName: String) -> String {
        // DummyFestivalData에서 페스티벌 객체 찾아오기
        guard let festival = DummyFestivalData.festivals.first(where: { $0.name == festivalName }) else {
            return ""
        }
        // 선택한 날짜(예: "1일차")에 해당하는 아티스트 스케줄 가져오기
        guard let daySchedule = festival.artistSchedule[preference.selectedDay] else {
            return ""
        }
        
        var allArtists: [ArtistForPrompt] = []
        for artistInfo in daySchedule {
            allArtists.append(contentsOf: artistInfo.artists.map {
                ArtistForPrompt(
                    artistName: $0.name,
                    imageName: $0.image,
                    location: artistInfo.location,
                    startTime: $0.startTime,
                    endTime: $0.endTime,
                    runningTime: $0.duration
                )
            })
        }
        
        // JSON 인코딩
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
        
        guard let artistJSON = try? String(data: encoder.encode(allArtists), encoding: .utf8) else {
            return ""
        }
        
        return """
        당신은 페스티벌 타임테이블 큐레이터입니다.
        
        **규칙:**
        - 반드시 아래 '오늘의 전체 라인업' JSON 목록에 있는 아티스트'만'을 사용해야 합니다.
        - 목록에 없는 아티스트를 절대로 추가하거나 생성해서는 안 됩니다.
        
        사용자 정보:
        - 선호 아티스트: \(preference.favoriteArtist)
        - 입장시간: \(preference.entryTime)
        - 퇴장시간: \(preference.exitTime)

        다음은 \(festival.name) \(preference.selectedDay) 라인업입니다:
        \(artistJSON)

        요청사항:
        - 사용자 입장~퇴장시간 내에서 선호 아티스트가 포함된 타임테이블을 생성
        - 선호 아티스트의 시간과 겹치는 다른 아티스트 제외
        - 선호 아티스트와 비슷한 아티스트들을 위주로 포함하여 타임테이블을 생성하기
        - location 3개를 적절히 섞어 추천할 것
        - 최소 5개 이상의 타임테이블로 구성하며 사용자가 공연을 볼 수 있는 시간에 꽉 차게 관람할 수 있도록 구성
        - 타임테이블은 공연 시작시간(startTime)을 기준으로 오름차순 정렬할 것
        - 출력은 다음 JSON 형식을 엄격히 따를 것
        {
          "TimetableData": [
            {
              "artistName": "",
              "imageName": "",
              "location": "",
              "startTime": "",
              "endTime": "",
              "runningTime": 0,
              "script": ""
            }
          ]
        }
        - TimetableData의 "script" 항목은 다음 문장 형식으로 작성하되 공백 포함 20자로 할 것
        - 예시: "까치산을 좋아한다면 이 무대도 추천해요!","인디 장르를 좋아하신다면 추천해요."
        - duration은 정수로만 넣을 것
        - script는 -요체로 끝내기
        - script는 사용자의 취향을 분석한 것으로 작성할 것
        """
    }
}

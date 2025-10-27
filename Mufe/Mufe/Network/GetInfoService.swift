//
//  GetInfoService.swift
//  Mufe
//
//  Created by 신혜연 on 6/14/25.
//

import Foundation

class GetInfoService {
    
    static let shared = GetInfoService()
    private init() {}
    
    private let apiKey = Bundle.main.infoDictionary?["API_KEY"] as! String
    private let urlString = "https://api.openai.com/v1/chat/completions"
    
    // GPT API 호출 후 Timetable 배열을 리턴하는 함수
    func fetchFestivalTimetable(preference: Preference, festival: Festival) async throws -> [Timetable] {
        guard let url = URL(string: urlString) else {
            throw NetworkError.requestEncodingError
        }
        
        // 1. 요청 바디 만들기
        let requestBody = makeChatRequestBody(preference: preference, festival: festival)
        
        // 2. JSON 인코딩
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let httpBody = try? encoder.encode(requestBody) else {
            throw NetworkError.requestEncodingError
        }
        
        // 3. URLRequest 구성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        print("Request body: \(String(data: httpBody, encoding: .utf8) ?? "")")
        
        // 4. URLSession 데이터 요청
        let (data, response) = try await URLSession.shared.data(for: request)
        print("Response: \(String(data: data, encoding: .utf8) ?? "")")
        
        // 5. HTTP 상태코드 체크
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.responseError
        }
        
        // 6. 응답 디코딩
        let decoder = JSONDecoder()
        let chatResponse = try decoder.decode(ChatResponseBody.self, from: data)
        
        // 7. GPT 응답 메시지에서 content 추출
        guard let content = chatResponse.choices.first?.message.content else {
            throw NetworkError.responseDecodingError
        }
        
        // 8. GPT가 준 JSON 텍스트에서 Timetable 데이터만 파싱
        return parseTimetableFromGPTResponse(content: content)
    }
    
    // GPT 응답 문자열에서 Timetable 배열 파싱 함수
    private func parseTimetableFromGPTResponse(content: String) -> [Timetable] {
        guard let startIndex = content.firstIndex(of: "{"),
              let endIndex = content.lastIndex(of: "}") else {
            print("JSON 포맷 시작 또는 끝 없음")
            return []
        }
        
        let jsonString = String(content[startIndex...endIndex])
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("UTF8 변환 실패")
            return []
        }
        
        struct TimetableWrapper: Codable {
            let TimetableData: [Timetable]
        }
        
        do {
            let decoder = JSONDecoder()
            let timetableWrapper = try decoder.decode(TimetableWrapper.self, from: jsonData)
            let timetables = timetableWrapper.TimetableData
            return timetables
        } catch {
            print("GPT 응답 파싱 실패: \(error)")
            print("파싱 대상 JSON: \(jsonString)")
            return []
        }
    }
}

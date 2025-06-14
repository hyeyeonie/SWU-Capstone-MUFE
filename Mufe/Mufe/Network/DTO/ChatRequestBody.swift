//
//  ChatRequestBody.swift
//  Mufe
//
//  Created by 신혜연 on 6/14/25.
//

import Foundation

struct ChatRequestBody: Encodable {
    let model: String
    let messages: [Message]
    let temperature: Double?

    struct Message: Encodable {
        let role: String
        let content: String
    }
}

func makeChatRequestBody(preference: Preference, festival: Festival) -> ChatRequestBody {
    let userContent = FestivalPromptBuilder.createPrompt(preference: preference, festivalName: festival.name)
    let systemMessage = ChatRequestBody.Message(role: "system", content: "You are a helpful festival timetable assistant.")
    let userMessage = ChatRequestBody.Message(role: "user", content: userContent)
    
    return ChatRequestBody(
        model: "gpt-4.1",
        messages: [systemMessage, userMessage],
        temperature: 0.7
    )
}


//
//  ChatResponseBody.swift
//  Mufe
//
//  Created by 신혜연 on 6/14/25.
//

import Foundation

struct ChatResponseBody: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let role: String
            let content: String
        }
        let index: Int
        let message: Message
        let finish_reason: String
    }
    
    let id: String
    let object: String
    let created: Int
    let choices: [Choice]
    
    struct Usage: Decodable {
        let prompt_tokens: Int
        let completion_tokens: Int
        let total_tokens: Int
    }
    let usage: Usage?
}

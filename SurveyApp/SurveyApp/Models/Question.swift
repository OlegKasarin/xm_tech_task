//
//  Question.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import Foundation

// MARK: - BE

struct QuestionResponse: Codable {
    let id: Int?
    let question: String?
}

// MARK: - Business

struct Question {
    let id: Int
    let question: String
    
    init?(response: QuestionResponse) {
        guard let id = response.id, let question = response.question else {
            return nil
        }
        self.id = id
        self.question = question
    }
    
    init(id: Int, question: String) {
        self.id = id
        self.question = question
    }
}

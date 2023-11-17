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
    var answer: String = ""
    
    // MARK: - Computed
    
    var isNoAnswer: Bool {
        answer.isEmpty
    }
}

extension Question {
    init?(response: QuestionResponse) {
        guard let id = response.id, let question = response.question else {
            return nil
        }
        
        self.init(id: id, question: question)
    }
}

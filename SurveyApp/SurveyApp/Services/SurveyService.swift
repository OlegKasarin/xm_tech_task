//
//  SurveyService.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import Foundation

protocol SurveyServiceProtocol {
    func fetch() async throws -> [Question]
}

final class SurveyService {
    private let executor: RequestExecutorProtocol
    
    init(executor: RequestExecutorProtocol) {
        self.executor = executor
    }
}

// MARK: - SurveyServiceProtocol

extension SurveyService: SurveyServiceProtocol {
    func fetch() async throws -> [Question] {
        let request = FetchQuestionsHTTPRequest()
        
        let response: [QuestionResponse] = try await executor.execute(request: request)
        let questions = response.compactMap {
            Question(response: $0)
        }
        
        return questions
    }
}

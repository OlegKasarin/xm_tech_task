//
//  SurveySubmitService.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import Foundation

protocol SurveySubmitServiceProtocol {
    func submit(id: Int, answer: String) async throws -> Bool
}

final class SurveySubmitService {
    private let executor: RequestExecutorProtocol
    
    init(executor: RequestExecutorProtocol) {
        self.executor = executor
    }
}

// MARK: - SurveySubmitServiceProtocol

extension SurveySubmitService: SurveySubmitServiceProtocol {
    func submit(id: Int, answer: String) async throws -> Bool {
        let request = SubmitQuestionHTTPRequest(id: id, answer: answer)
        
        let _: URLResponsePayload = try await executor.execute(request: request)
        
        return true
    }
}

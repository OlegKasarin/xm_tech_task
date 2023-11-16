//
//  SurveySubmitService.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import Foundation

protocol SurveySubmitServiceProtocol {
    func submit(id: Int, answer: String) -> Bool
}

final class SurveySubmitService {
    private let executor: RequestExecutorProtocol
    
    init(executor: RequestExecutorProtocol) {
        self.executor = executor
    }
}

// MARK: - SurveySubmitServiceProtocol

extension SurveySubmitService: SurveySubmitServiceProtocol {
    func submit(id: Int, answer: String) -> Bool {
        return false
    }
}

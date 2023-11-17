//
//  SurveySubmitServiceSpy.swift
//  SurveyAppTests
//
//  Created by Oleg Kasarin on 17/11/2023.
//

import Foundation
@testable import SurveyApp

final class SurveySubmitServiceSpy: SurveySubmitServiceProtocol {
    var invokedSubmit = false
    var invokedSubmitCount = 0
    var stubbedSubmitError: Error?
    var stubbedSubmitResult = false
    var invokedSubmitParameters: (id: Int, answer: String)?
    var invokedSubmitParametersList = [(id: Int, answer: String)]()
    
    func submit(id: Int, answer: String) async throws -> Bool {
        invokedSubmit = true
        invokedSubmitCount += 1
        invokedSubmitParameters = (id, answer)
        invokedSubmitParametersList.append((id, answer))
        
        if let error = stubbedSubmitError {
            throw error
        }
        
        return stubbedSubmitResult
    }
}

//
//  SurveyServiceSpy.swift
//  SurveyAppTests
//
//  Created by Oleg Kasarin on 17/11/2023.
//

import Foundation
@testable import SurveyApp

final class SurveyServiceSpy: SurveyServiceProtocol {
    var invokedFetch = false
    var invokedFetchCount = 0
    var stubbedFetchError: Error?
    var stubbedFetchResult: [Question] = []
    
    func fetch() async throws -> [Question] {
        invokedFetch = true
        invokedFetchCount += 1
        
        if let error = stubbedFetchError {
            throw error
        }
        
        return stubbedFetchResult
    }
}

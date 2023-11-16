//
//  ServiceAssembly.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import Foundation

final class ServiceAssembly {
    private static let shared = ServiceAssembly()
    
    static var surveyService: SurveyServiceProtocol {
        SurveyService(executor: NetworkAssembly.requestExecutor)
    }
    
    static var surveySubmitService: SurveySubmitServiceProtocol {
        SurveySubmitService(executor: NetworkAssembly.requestExecutor)
    }
}

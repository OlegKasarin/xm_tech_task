//
//  SubmittedAnswerState.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 17/11/2023.
//

import Foundation

enum SubmittedAnswerState {
    case none
    case inProgress
    case success
    case failure
    
    var isNone: Bool {
        switch self {
        case .none:
            return true
        case .inProgress, .success, .failure:
            return false
        }
    }
}

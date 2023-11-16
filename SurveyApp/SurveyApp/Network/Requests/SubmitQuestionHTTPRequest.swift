//
//  SubmitQuestionHTTPRequest.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import Foundation

struct SubmitQuestionHTTPRequest: HTTPRequest {
    let id: Int
    let answer: String
    
    // MARK: - HTTPRequest
    
    var method: HTTPRequestMethod {
        .post
    }
    
    var baseURL: String {
        ""
    }
    
    var pathPattern: HTTPPathPattern {
        .submitQuestion
    }
    
    var bodyPayload: HTTPBody? {
        [
            "id": id,
            "answer": answer
        ]
    }
}

//
//  FetchQuestionsHTTPRequest.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import Foundation

struct FetchQuestionsHTTPRequest: HTTPRequest {
    var method: HTTPRequestMethod {
        .get
    }
    
    var baseURL: String {
        ""
    }
    
    var pathPattern: HTTPPathPattern {
        .questions
    }
    
    var bodyPayload: HTTPBody? {
        nil
    }
}

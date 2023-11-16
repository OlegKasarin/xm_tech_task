//
//  HTTPRequest.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import Foundation

enum HTTPRequestMethod: String {
    case get = "GET"
    case post = "POST"
}

typealias HTTPBody = [String: Any]

protocol HTTPRequest {
    var method: HTTPRequestMethod { get }
    var baseURL: String { get }
    var pathPattern: HTTPPathPattern { get }
    var bodyPayload: HTTPBody? { get }
}

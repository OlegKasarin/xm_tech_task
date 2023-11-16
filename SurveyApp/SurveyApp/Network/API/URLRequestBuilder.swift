//
//  URLRequestBuilder.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import Foundation

protocol URLRequestBuilderProtocol {
    func buildThrows(request: HTTPRequest) throws -> URLRequest
}

final class URLRequestBuilder: URLRequestBuilderProtocol {
    private let baseURLString = "https://xm-assignment.web.app"
    
    enum URLRequestBuilderError: Error {
        case invalidBaseURL
        case invalidURLParameters
        case invalidBodyPayload
    }
    
    func buildThrows(request: HTTPRequest) throws -> URLRequest {
        do {
            let url = try buildURL(request: request)
            return try buildURLRequest(url: url, request: request)
        } catch {
            throw error
        }
    }
}

// MARK: - Private API

private extension URLRequestBuilder {
    func buildURL(request: HTTPRequest) throws -> URL {
        guard let baseURL = URL(string: baseURLString) else {
            throw URLRequestBuilderError.invalidBaseURL
        }
        
        do {
            let url = try buildURL(baseURL: baseURL, request: request)
            return url
        } catch let error {
            throw error
        }
    }
    
    func buildURL(baseURL: URL, request: HTTPRequest) throws -> URL {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            throw URLRequestBuilderError.invalidBaseURL
        }
        
        components.path += request.pathPattern.rawValue
        
        guard let url = components.url else {
            throw URLRequestBuilderError.invalidURLParameters
        }
        
        return url
    }
    
    func buildURLRequest(url: URL, request: HTTPRequest) throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        do {
            let body = try buildBody(request: request)
            urlRequest.httpBody = body
        } catch let error {
            throw error
        }
        
        return urlRequest
    }
    
    func buildBody(request: HTTPRequest) throws -> Data? {
        var body: HTTPBody = [:]
        
        if let payload = request.bodyPayload {
            body = body.merging(payload, uniquingKeysWith: { (current, _) in current })
        }
        
        if body.isEmpty {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            return data
        } catch {
            throw URLRequestBuilderError.invalidBodyPayload
        }
    }
}

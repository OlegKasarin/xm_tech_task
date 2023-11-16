//
//  RequestExecutor.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import Foundation

typealias URLResponsePayload = (response: URLResponse?, data: Data?)

protocol RequestExecutorProtocol {
    func execute<T: Decodable>(request: HTTPRequest) async throws -> T
    func execute(request: HTTPRequest) async throws -> URLResponsePayload
}

final class RequestExecutor {
    private let builder: URLRequestBuilderProtocol
    
    init(builder: URLRequestBuilderProtocol) {
        self.builder = builder
    }
}

// MARK: - RequestExecutorProtocol

extension RequestExecutor: RequestExecutorProtocol {
    func execute<T: Decodable>(request: HTTPRequest) async throws -> T {
        let urlRequest = try builder.buildThrows(request: request)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "Error"
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func execute(request: HTTPRequest) async throws -> URLResponsePayload {
        let urlRequest = try builder.buildThrows(request: request)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "Error"
        }
        
        let payload: URLResponsePayload = (response: response, data: data)
        return payload
    }
}

extension String: Error { }

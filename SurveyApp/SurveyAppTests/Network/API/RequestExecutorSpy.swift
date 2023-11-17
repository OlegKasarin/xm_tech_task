//
//  RequestExecutorSpy.swift
//  SurveyAppTests
//
//  Created by Oleg Kasarin on 16/11/2023.
//

import Foundation
@testable import SurveyApp

final class RequestExecutorSpy: RequestExecutorProtocol {
    var invokedExecuteRequestT = false
    var invokedExecuteRequestTCount = 0
    var stubbedExecuteRequestTError: Error?
    var stubbedExecuteRequestTResult: Any!
    
    func execute<T: Decodable>(request: HTTPRequest) async throws -> T {
        invokedExecuteRequestT = true
        invokedExecuteRequestTCount += 1
        
        await Task(priority: .medium) {
          await withUnsafeContinuation { continuation in
            Thread.sleep(forTimeInterval: 1)
            continuation.resume()
          }
        }.value
        
        if let error = stubbedExecuteRequestTError {
            throw error
        }
        
        return stubbedExecuteRequestTResult as! T
    }
    
    var invokedExecuteRequestPayload = false
    var invokedExecuteRequestPayloadCount = 0
    var stubbedExecuteError: Error?
    var stubbedExecuteResult: URLResponsePayload = (response: nil, data: nil)
    
    func execute(request: HTTPRequest) async throws -> URLResponsePayload {
        invokedExecuteRequestPayload = true
        invokedExecuteRequestPayloadCount += 1
        
        await Task(priority: .medium) {
          await withUnsafeContinuation { continuation in
            Thread.sleep(forTimeInterval: 1)
            continuation.resume()
          }
        }.value
        
        if let error = stubbedExecuteError {
            throw error
        }
        return stubbedExecuteResult
    }
}

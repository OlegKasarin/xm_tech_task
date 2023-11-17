//
//  SurveySubmitServiceTests.swift
//  SurveyAppTests
//
//  Created by Oleg Kasarin on 17/11/2023.
//

@testable import SurveyApp
import XCTest

final class SurveySubmitServiceTests: XCTestCase {
    private var sut: SurveySubmitServiceProtocol!

    private var requestExecutorSpy: RequestExecutorSpy!
    
    override func setUpWithError() throws {
        requestExecutorSpy = RequestExecutorSpy()
        sut = SurveySubmitService(executor: requestExecutorSpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        requestExecutorSpy = nil
    }

    func testSubmitSuccess() async throws {
        requestExecutorSpy.stubbedExecuteResult = URLResponsePayload(response: nil, data: nil)
        let result = try await sut.submit(id: 1, answer: "A")
        
        XCTAssertTrue(result)
        
        XCTAssertTrue(requestExecutorSpy.invokedExecuteRequestPayload)
        XCTAssertEqual(requestExecutorSpy.invokedExecuteRequestPayloadCount, 1)
        
        XCTAssertFalse(requestExecutorSpy.invokedExecuteRequestT)
        XCTAssertEqual(requestExecutorSpy.invokedExecuteRequestTCount, 0)
    }

    func testSubmitFailure() async throws {
        requestExecutorSpy.stubbedExecuteError = "error"
        
        do {
            let _ = try await sut.submit(id: 1, answer: "A")
        } catch {
            XCTAssertNotNil(error)
        }
        
        XCTAssertTrue(requestExecutorSpy.invokedExecuteRequestPayload)
        XCTAssertEqual(requestExecutorSpy.invokedExecuteRequestPayloadCount, 1)
        
        XCTAssertFalse(requestExecutorSpy.invokedExecuteRequestT)
        XCTAssertEqual(requestExecutorSpy.invokedExecuteRequestTCount, 0)
    }
}

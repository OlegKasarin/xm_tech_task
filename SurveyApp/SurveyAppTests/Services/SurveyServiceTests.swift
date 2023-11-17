//
//  SurveyServiceTests.swift
//  SurveyAppTests
//
//  Created by Oleg Kasarin on 16/11/2023.
//

@testable import SurveyApp
import XCTest

final class SurveyServiceTests: XCTestCase {
    private var sut: SurveyServiceProtocol!
    
    private var requestExecutorSpy: RequestExecutorSpy!
    
    override func setUpWithError() throws {
        requestExecutorSpy = RequestExecutorSpy()
        sut = SurveyService(executor: requestExecutorSpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        requestExecutorSpy = nil
    }

    func testFetchSuccess() async throws {
        requestExecutorSpy.stubbedExecuteRequestTResult = mockQuestions
        let questions = try await sut.fetch()
        
        XCTAssertFalse(questions.isEmpty)
        
        XCTAssertTrue(requestExecutorSpy.invokedExecuteRequestT)
        XCTAssertEqual(requestExecutorSpy.invokedExecuteRequestTCount, 1)
        
        XCTAssertFalse(requestExecutorSpy.invokedExecuteRequestPayload)
        XCTAssertEqual(requestExecutorSpy.invokedExecuteRequestPayloadCount, 0)
    }
    
    func testFetchFailure() async throws {
        requestExecutorSpy.stubbedExecuteRequestTError = "error"
        
        do {
            let _ = try await sut.fetch()
        } catch {
            XCTAssertNotNil(error)
        }
        
        XCTAssertTrue(requestExecutorSpy.invokedExecuteRequestT)
        XCTAssertEqual(requestExecutorSpy.invokedExecuteRequestTCount, 1)
        
        XCTAssertFalse(requestExecutorSpy.invokedExecuteRequestPayload)
        XCTAssertEqual(requestExecutorSpy.invokedExecuteRequestPayloadCount, 0)
    }

}

private var mockQuestions: [QuestionResponse] {
    [
        QuestionResponse(id: 11, question: "What is your favourite band?"),
        QuestionResponse(id: 22, question: "What is your favourite programming language?"),
        QuestionResponse(id: 33, question: "What is your favourite food?"),
        QuestionResponse(id: 44, question: "What is your favourite singer?")
    ]
}

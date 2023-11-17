//
//  SurveyViewModelTests.swift
//  SurveyAppTests
//
//  Created by Oleg Kasarin on 17/11/2023.
//

@testable import SurveyApp
import XCTest

final class SurveyViewModelTests: XCTestCase {
    private var sut: SurveyViewModel!

    private var surveyServiceSpy: SurveyServiceSpy!
    private var surveySubmitServiceSpy: SurveySubmitServiceSpy!
    
    override func setUpWithError() throws {
        surveyServiceSpy = SurveyServiceSpy()
        surveySubmitServiceSpy = SurveySubmitServiceSpy()
        
        sut = SurveyViewModel(
            surveyService: surveyServiceSpy,
            surveySubmitService: surveySubmitServiceSpy
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        surveyServiceSpy = nil
        surveySubmitServiceSpy = nil
    }

    func testDidLoad() async throws {
        let mockQuestion = Question(id: 1, question: "Q1?")
        surveyServiceSpy.stubbedFetchResult = [mockQuestion]
        
        let _ = try await sut.didLoad()
        
        XCTAssertEqual(sut.currentIndex, 0)
        XCTAssertEqual(sut.submittedState, SubmittedAnswerState.none)
        
        XCTAssertTrue(surveyServiceSpy.invokedFetch)
        XCTAssertFalse(surveySubmitServiceSpy.invokedSubmit)
        
        XCTAssertEqual(sut.questions.count, 1)
        
        let firstQuestion = sut.questions.first!
        XCTAssertEqual(firstQuestion.id, mockQuestion.id)
        XCTAssertEqual(firstQuestion.question, mockQuestion.question)
        XCTAssertTrue(firstQuestion.answer.isEmpty)
        
        XCTAssertEqual(sut.currentIndex, 0)
        XCTAssertEqual(sut.submittedState, SubmittedAnswerState.none)
        
        XCTAssertEqual(sut.navigationTitle, "Question 1/1")
        XCTAssertTrue(sut.isPreviousButtonDisabled)
        XCTAssertTrue(sut.isNextButtonDisabled)
        XCTAssertEqual(sut.counterTitle, "Questions submitted: 0")
        XCTAssertEqual(sut.buttonTitle, "Submit")
        XCTAssertFalse(sut.isAlreadySubmittedQuestion)
    }
    
    func testSubmitResultTrue() async throws {
        let mockQuestion = Question(id: 2, question: "Q2?", answer: "A2")
        sut.questions = [mockQuestion]
        
        surveySubmitServiceSpy.stubbedSubmitResult = true
        
        try await sut.submit()
        
        XCTAssertTrue(surveySubmitServiceSpy.invokedSubmit)
        XCTAssertFalse(surveyServiceSpy.invokedFetch)
        
        XCTAssertEqual(sut.questions.count, 1)
        
        let firstQuestion = sut.questions.first!
        XCTAssertEqual(firstQuestion.id, mockQuestion.id)
        XCTAssertEqual(firstQuestion.question, mockQuestion.question)
        XCTAssertEqual(firstQuestion.answer, mockQuestion.answer)
        
        XCTAssertEqual(sut.currentIndex, 0)
        XCTAssertEqual(sut.submittedState, SubmittedAnswerState.success)
        
        XCTAssertEqual(sut.navigationTitle, "Question 1/1")
        XCTAssertTrue(sut.isPreviousButtonDisabled)
        XCTAssertTrue(sut.isNextButtonDisabled)
        XCTAssertEqual(sut.counterTitle, "Questions submitted: 1")
        XCTAssertEqual(sut.buttonTitle, "Already submitted")
        XCTAssertTrue(sut.isSubmitButtonDisabled)
        XCTAssertTrue(sut.isAlreadySubmittedQuestion)
    }
    
    func testSubmitResultFalse() async throws {
        let mockQuestion3 = Question(id: 3, question: "Q3?")
        let mockQuestion4 = Question(id: 4, question: "Q4?")
        sut.questions = [mockQuestion3, mockQuestion4]
        
        surveySubmitServiceSpy.stubbedSubmitResult = false
        
        try await sut.submit()
        
        XCTAssertTrue(surveySubmitServiceSpy.invokedSubmit)
        XCTAssertFalse(surveyServiceSpy.invokedFetch)
        
        XCTAssertEqual(sut.questions.count, 2)
        
        let lastQuestion = sut.questions.last!
        XCTAssertEqual(lastQuestion.id, mockQuestion4.id)
        XCTAssertEqual(lastQuestion.question, mockQuestion4.question)
        XCTAssertEqual(lastQuestion.answer, "")
        
        XCTAssertEqual(sut.currentIndex, 0)
        XCTAssertEqual(sut.submittedState, SubmittedAnswerState.failure)
        
        XCTAssertEqual(sut.navigationTitle, "Question 1/2")
        XCTAssertTrue(sut.isPreviousButtonDisabled)
        XCTAssertFalse(sut.isNextButtonDisabled)
        XCTAssertEqual(sut.counterTitle, "Questions submitted: 0")
        XCTAssertEqual(sut.buttonTitle, "Submit")
        XCTAssertTrue(sut.isSubmitButtonDisabled)
        XCTAssertFalse(sut.isAlreadySubmittedQuestion)
    }
}

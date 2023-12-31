//
//  SurveyViewModel.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import Foundation

final class SurveyViewModel: ObservableObject {
    let popupDurationTime = 5.0
    
    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    
    @Published private var submittedQuestions: Set<Int> = []
    
    @Published var submittedState = SubmittedAnswerState.none
    
    // MARK: - Computed
    
    var currentQuestion: Question? {
        guard questions.indices.contains(currentIndex) else {
            return nil
        }
        
        return questions[currentIndex]
    }
    
    var navigationTitle: String {
        questions.isEmpty
            ? ""
            : "Question \(currentIndex + 1)/\(questions.count)"
    }
    
    var isPreviousButtonDisabled: Bool {
        currentIndex == 0 || questions.isEmpty
    }
    
    var isNextButtonDisabled: Bool {
        currentIndex == questions.count - 1 || questions.isEmpty
    }
    
    var counterTitle: String {
        "Questions submitted: \(submittedQuestions.count)"
    }
    
    var buttonTitle: String {
        isAlreadySubmittedQuestion
            ? "Already submitted"
            : "Submit"
    }
    
    var isSubmitButtonDisabled: Bool {
        guard let currentQuestion else {
            return true
        }
        
        return currentQuestion.isNoAnswer
        || !submittedState.isNone
        || isAlreadySubmittedQuestion
    }
    
    var isAlreadySubmittedQuestion: Bool {
        guard let currentQuestion else {
            return false
        }
        
        return submittedQuestions.contains(currentQuestion.id)
    }
    
    // MARK: - Dependencies
    
    private let surveyService: SurveyServiceProtocol
    private let surveySubmitService: SurveySubmitServiceProtocol
    
    init(
        surveyService: SurveyServiceProtocol,
        surveySubmitService: SurveySubmitServiceProtocol
    ) {
        self.surveyService = surveyService
        self.surveySubmitService = surveySubmitService
    }
    
    func didLoad() async throws {
        await fetchQuestions()
    }
    
    @MainActor
    func submit() async throws {
        submittedState = .inProgress
        
        guard
            let currentQuestion = currentQuestion
        else {
            submittedState = .failure
            return
        }
        
        await submit(id: currentQuestion.id, answer: currentQuestion.answer)
    }
}

// MARK: - Private API

private extension SurveyViewModel {
    @MainActor
    func fetchQuestions() async {
        do {
            questions = try await surveyService.fetch()
        } catch {
            questions = []
        }
    }
    
    @MainActor
    func submit(id: Int, answer: String) async {
        do {
            let result = try await surveySubmitService.submit(id: id, answer: answer)
            
            guard result else {
                submittedState = .failure
                return
            }
            
            // store id of submitted answer
            submittedQuestions.insert(id)
            
            submittedState = .success
        } catch {
            submittedState = .failure
        }
    }
}

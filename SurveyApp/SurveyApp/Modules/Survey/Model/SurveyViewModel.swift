//
//  SurveyViewModel.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import Foundation

enum SubmittedAnswerState {
    case none
    case success
    case failure
}

final class SurveyViewModel: ObservableObject {
    
    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    
    var currentQuestion: Question? {
        guard questions.indices.contains(currentIndex) else {
            return nil
        }
        
        return questions[currentIndex]
    }
    
    @Published var submittedQuestions: [Int: String] = [:]
    @Published var submittedState = SubmittedAnswerState.none
    
    private let surveyService: SurveyServiceProtocol
    private let surveySubmitService: SurveySubmitServiceProtocol
    
    init(
        surveyService: SurveyServiceProtocol,
        surveySubmitService: SurveySubmitServiceProtocol
    ) {
        self.surveyService = surveyService
        self.surveySubmitService = surveySubmitService
    }
    
    func didLoad() {
        Task {
            await fetchQuestions()
        }
    }
    
    func submit() {
        guard 
            let currentQuestion = currentQuestion
        else {
            submittedState = .failure
            return
        }
        
        Task {
            await submit(id: currentQuestion.id, answer: currentQuestion.answer)
        }
    }
}

// MARK: - Private API

private extension SurveyViewModel {
    @MainActor
    func fetchQuestions() async {
        do {
            questions = try await surveyService.fetch()
            print(questions)
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
            
            // store submitted answer
            submittedQuestions[id] = answer
            
            submittedState = .success
        } catch {
            submittedState = .failure
        }
    }
}


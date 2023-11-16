//
//  SurveyView.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import SwiftUI

struct SurveyView: View {
    @ObservedObject var viewModel: SurveyViewModel
    
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
            
            SurveyContentView(viewModel: viewModel)
        }
    }
}

struct SurveyContentView: View {
    @ObservedObject var viewModel: SurveyViewModel
    
    @FocusState private var isTextViewFocused: Bool
    
    private let popupDuration = 5.0
    
    var body: some View {
        VStack {
            
            switch viewModel.submittedState {
            case .none:
                Text("Questions submitted: \(viewModel.submittedQuestions.count)")
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.white)
                    .padding()
            case .success:
                Text("Success")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity)
                    .frame(height: 140)
                    .background(Color.green)
                    .padding()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + popupDuration) {
                            self.viewModel.submittedState = .none
                        }
                    }
                
            case .failure:
                HStack {
                    Text("Failure!")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity)
                    Button("RETRY") {
                        Task {
                            viewModel.submit()
                        }
                    }
                    .foregroundColor(Color.black)
                    .frame(width: 100, height: 35)
                    .background(Color.red)
                    .border(Color.gray, width: 3)
                    .cornerRadius(5)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 140)
                .padding()
                .background(Color.red)
                .padding()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + popupDuration) {
                        self.viewModel.submittedState = .none
                    }
                }
                
            }
             
            Text(viewModel.currentQuestion?.question ?? "")
                .font(.title.bold())
                .padding()
            
            if !viewModel.questions.isEmpty {
                TextField(
                    "Type here for an answer...",
                    text: $viewModel.questions[viewModel.currentIndex].answer,
                    axis: .horizontal
                )
                .focused($isTextViewFocused)
                .submitLabel(.done)
                .lineLimit(1)
                .autocorrectionDisabled()
                .font(.title)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit(of: .text) {
                    isTextViewFocused = false
                }
            }
            
            Spacer()
            
            if let currentQuestion = viewModel.currentQuestion {
                let isNoAnswer = currentQuestion.answer.isEmpty
                let isAlreadySubmitted = viewModel.submittedQuestions[currentQuestion.id] != nil
                let isSubmitButtonDisabled = isNoAnswer || isAlreadySubmitted
                
                Button(
                    isAlreadySubmitted
                        ? "Already submitted"
                        : "Submit"
                ) {
                    Task {
                        isTextViewFocused = false
                        viewModel.submit()
                    }
                }
                .frame(width: 300, height: 48)
                .background(Color.white)
                .cornerRadius(10)
                .disabled(isSubmitButtonDisabled)
            } else {
                ProgressView()
            }
            
            Spacer()
        }
        .navigationTitle(
            viewModel.questions.isEmpty
                ? ""
                : "Question \(viewModel.currentIndex + 1)/\(viewModel.questions.count)"
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 5) {
                    Button {
                        viewModel.currentIndex -= 1
                    } label: {
                        Text("Previous")
                    }
                    .disabled(viewModel.currentIndex == 0 || viewModel.questions.isEmpty)
                    
                    Button {
                        viewModel.currentIndex += 1
                    } label: {
                        Text("Next")
                    }
                    .disabled(viewModel.currentIndex == viewModel.questions.count - 1 || viewModel.questions.isEmpty)
                }
                
            }
        }
        .onLoad {
            viewModel.didLoad()
        }
    }
}

#Preview {
    SurveyView(
        viewModel: SurveyViewModel(
            surveyService: ServiceAssembly.surveyService,
            surveySubmitService: ServiceAssembly.surveySubmitService
        )
    )
}

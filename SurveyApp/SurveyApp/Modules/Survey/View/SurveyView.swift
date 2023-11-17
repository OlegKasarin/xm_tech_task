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

// MARK: - SurveyContentView

struct SurveyContentView: View {
    @ObservedObject var viewModel: SurveyViewModel
    
    private var currentQuestion: String {
        viewModel.currentQuestion?.question ?? ""
    }
    
    var body: some View {
        VStack {
            SurveyBannerView(viewModel: viewModel)
            
            questionTextView(text: currentQuestion)
            
            if let _ = viewModel.currentQuestion {
                SurveySubmitAnswerView(viewModel: viewModel)
            } else {
                ProgressView()
            }
            
            Spacer()
        }
        .navigationTitle(
            viewModel.navigationTitle
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 5) {
                    button(text: "Previous", isDisabled: viewModel.isPreviousButtonDisabled) {
                        viewModel.currentIndex -= 1
                    }
                    
                    button(text: "Next", isDisabled: viewModel.isNextButtonDisabled) {
                        viewModel.currentIndex += 1
                    }
                }
            }
        }
        .onLoad {
            viewModel.didLoad()
        }
    }
    
    private func questionTextView(text: String) -> some View {
        Text(text)
            .font(.title.bold())
            .foregroundColor(Color.black)
            .padding()
    }
    
    private func button(
        text: String,
        isDisabled: Bool,
        action: @escaping () -> ()
    ) -> some View {
        Button {
            action()
        } label: {
            Text(text)
        }
        .disabled(isDisabled)
    }
}

// MARK: - SurveyBannerView

struct SurveyBannerView: View {
    @ObservedObject var viewModel: SurveyViewModel
    
    private var popupDurationTime: Double {
        viewModel.popupDurationTime
    }
    
    var body: some View {
        switch viewModel.submittedState {
        case .none, .inProgress:
            counterView(text: viewModel.counterTitle)
        case .success:
            successBannerView(text: "Success")
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + popupDurationTime) {
                        self.viewModel.submittedState = .none
                    }
                }
        case .failure:
            failureBannerView(text: "Failure!", retryButtonText: "RETRY") {
                Task {
                    viewModel.submit()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupDurationTime) {
                    self.viewModel.submittedState = .none
                }
            }
        }
    }
    
    private func counterView(text: String) -> some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(Color.white)
            .padding()
    }
    
    private func successBannerView(text: String) -> some View {
        Text(text)
            .font(.title.bold())
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(Color.green)
            .padding()
    }
    
    private func failureBannerView(
        text: String,
        retryButtonText: String,
        retryAction: @escaping () -> ()
    ) -> some View {
        HStack {
            Text(text)
                .font(.title.bold())
                .frame(maxWidth: .infinity)
            Button(retryButtonText) {
                Task {
                    retryAction()
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
    }
}

// MARK: - SurveyTextFieldView

struct SurveySubmitAnswerView: View {
    @ObservedObject var viewModel: SurveyViewModel
    
    private let textFieldPlaceholder = "Type here for an answer..."
    @FocusState private var isTextViewFocused: Bool
    
    var body: some View {
        TextField(
            textFieldPlaceholder,
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
        .disabled(viewModel.isAlreadySubmittedQuestion)
        .onSubmit(of: .text) {
            isTextViewFocused = false
        }
        
        Spacer()
        
        submitButton(
            title: viewModel.buttonTitle,
            isDisabled: viewModel.isSubmitButtonDisabled
        ) {
            Task {
                isTextViewFocused = false
                viewModel.submit()
            }
        }
    }
    
    private func submitButton(
        title: String,
        isDisabled: Bool,
        action: @escaping () -> ()
    ) -> some View {
        Button(title) {
            action()
        }
        .frame(width: 300, height: 48)
        .background(Color.white)
        .cornerRadius(10)
        .disabled(isDisabled)
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

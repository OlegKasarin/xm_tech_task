//
//  HomeView.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import SwiftUI

enum NavigationType: String, Hashable {
    case survey
}

struct HomeView: View {
    @State var mainStack: [NavigationType] = []
    
    var body: some View {
        NavigationStack(path: $mainStack) {
            ZStack {
                Color.gray
                    .ignoresSafeArea()
                
                Spacer()
                
                Button("Start Survey") {
                    mainStack.append(.survey)
                }
                .frame(width: 300, height: 48)
                .background(Color.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: NavigationType.self) { value in
                switch value {
                case .survey:
                    let surveyViewModel = SurveyViewModel(
                        surveyService: ServiceAssembly.surveyService,
                        surveySubmitService: ServiceAssembly.surveySubmitService
                    )
                    SurveyView(viewModel: surveyViewModel)
                        .toolbarRole(.editor)
                }
            }
        }    
    }
}

#Preview {
    HomeView()
}

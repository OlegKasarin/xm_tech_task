//
//  HomeView.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray
                    .ignoresSafeArea()
                
                Spacer()
                
                Button("Start Survey") {
                    //
                }
                .frame(width: 300, height: 48)
                .background(Color.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .navigationTitle("Welcome")
            
        }
    }
}

#Preview {
    HomeView()
}

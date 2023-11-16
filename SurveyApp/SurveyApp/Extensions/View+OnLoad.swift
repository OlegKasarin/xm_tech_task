//
//  View+OnLoad.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 16/11/2023.
//

import Foundation
import SwiftUI

public struct ViewDidLoadModifier: ViewModifier {

    @State private var didLoad = false
    private let action: (() -> Void)?

    public init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    public func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
}

extension View {
    public func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}

//
//  NetworkAssembly.swift
//  SurveyApp
//
//  Created by Oleg Kasarin on 15/11/2023.
//

import Foundation

struct NetworkAssembly {
    static var requestExecutor: RequestExecutorProtocol {
        RequestExecutor(builder: URLRequestBuilder())
    }
}

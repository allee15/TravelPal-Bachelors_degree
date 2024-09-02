//
//  ErrorInterceptor.swift
//  TravelPal
//
//  Created by Alexia Aldea on 02.09.2024.
//

import Combine
import Alamofire

class ErrorInterceptor {
    private let subject = PassthroughSubject<ErrorEvent, Never>()
    
    func errors() -> AnyPublisher<ErrorEvent, Never> {
        subject.eraseToAnyPublisher()
    }
    
    func notify(_ errorEvent: ErrorEvent) {
        subject.send(errorEvent)
    }
}

struct ErrorEvent {
    let throwable: Error
    let message: String
}

let noInternetInterceptor = ErrorInterceptor()

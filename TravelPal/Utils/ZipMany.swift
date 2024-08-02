//
//  ZipMany.swift
//  TravelPal
//
//  Created by Ovidiu Stoica on 21.08.2023.
//

import Foundation
import Combine

struct ZipMany<Element, Failure>: Publisher where Failure: Error {
    typealias Output = [Element]

    private let underlying: AnyPublisher<Output, Failure>

    init<T: Publisher>(publishers: [T]) where T.Output == Element, T.Failure == Failure {
        let zipped: AnyPublisher<[T.Output], T.Failure>? = publishers.reduce(nil) { result, publisher in
            if let result = result {
                return publisher.zip(result).map { element, array in
                    array + [element]
                }.eraseToAnyPublisher()
            } else {
                return publisher.map { [$0] }.eraseToAnyPublisher()
            }
        }
        underlying = zipped!// ?? P Publishers.Empty(completeImmediately: false)
            .eraseToAnyPublisher()
    }

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        underlying.receive(subscriber: subscriber)
    }
}

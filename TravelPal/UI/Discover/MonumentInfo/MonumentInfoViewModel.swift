//
//  File.swift
//  TravelPal
//
//  Created by Alexia Aldea on 05.09.2024.
//

import Foundation
import Combine

enum MonumentInfoState {
    case loading
    case failure(Error)
    case value(Monument)
}

enum MonumentInfoCompletion {
    case completed
}

class MonumentInfoViewModel: BaseViewModel {
    private var monumentInfoService = MonumentInfoService.shared
    
    @Published var monumentInfoState = MonumentInfoState.loading
    
    let monumentInfoCompletion = PassthroughSubject<MonumentInfoCompletion, Never>()
    let monumentName: String
    
    init(monumentName: String) {
        self.monumentName = monumentName
        super.init()
        self.loadMonumentInfo()
    }
    
    func loadMonumentInfo() {
        monumentInfoState = .loading
        let monument = self.replaceSpacesWithUnderscores(input: self.monumentName)
        monumentInfoService.getInfo(monumentName: monument)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else {return}
                switch completion {
                case .failure(let error):
                    self.monumentInfoState = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] monument in
                guard let self else {return}
                self.monumentInfoCompletion.send(.completed)
                self.monumentInfoState = .value(monument)
            } .store(in: &bag)
    }
    
    func replaceSpacesWithUnderscores(input: String) -> String {
        return input.replacingOccurrences(of: " ", with: "_")
    }
}

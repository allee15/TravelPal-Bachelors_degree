//
//  BaseViewModel.swift
//  TravelPal
//
//  Created by Aldea Alexia on 04.08.2023.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    var bag = Set<AnyCancellable>()
}

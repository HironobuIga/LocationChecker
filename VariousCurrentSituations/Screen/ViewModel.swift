//
//  ViewModel.swift
//  VariousCurrentSituations
//
//  Created by iganin on 2018/07/21.
//  Copyright © 2018年 iganin. All rights reserved.
//

import CoreLocation

final class ViewModel {
    enum State {
        case none, loading, success(string: String), failure(error: Error?)
    }
    
    // MARK: - Property
    private var state: State = .none {
        didSet {
            didChangeState?(state)
        }
    }
    private let geoCoderRequester = GeoCoderRequester()
    var didChangeState: ((State) -> Void)?
    
    // MARK: - Life Cycle
    init() {
        geoCoderRequester.didChangeState = { [weak self] state in
            guard let `self` = self else { return }
            switch state {
            case .none: break
            case .loading: self.state = .loading
            case .failure(let error):
                self.state = .failure(error: error)
            case .success(let result):
                self.state = .success(string: result)
            }
        }
    }
    
    // MARK: - Function
    func fetchLocationName(_ location: CLLocation?) {
        guard let location = location else { return }
        geoCoderRequester.getLocationInformations(location: location)
    }
}

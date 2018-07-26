//
//  GeoCoderRequester.swift
//  VariousCurrentSituations
//
//  Created by iganin on 2018/07/21.
//  Copyright © 2018年 iganin. All rights reserved.
//

import Foundation
import CoreLocation

final class GeoCoderRequester {
    
    enum State {
        case none
        case loading
        case success(result: CLPlacemark?)
        case failure(error: Error?)
    }
    
    // MARK: - Property
    var didChangeState: ((State) -> Void)?
    private var state: State = .none {
        didSet {
            didChangeState?(state)
        }
    }
    
    // MARK: - Method
    func getLocationInformations(location: CLLocation) {
        state = .loading
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { [weak self] (landmarks, error) in
            if let error = error {
                self?.state = .failure(error: error)
                return
            }
            self?.state = .success(result: landmarks?.first)
        }
    }
}

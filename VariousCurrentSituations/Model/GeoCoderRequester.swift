//
//  GeoCoderRequester.swift
//  VariousCurrentSituations
//
//  Created by iganin on 2018/07/21.
//  Copyright © 2018年 iganin. All rights reserved.
//

import Foundation
import CoreLocation

class GeoCoderRequester {
    
    enum State {
        case none
        case loading
        case success(result: String)
        case failure(error: Error?)
    }
    var didChangeState: ((State) -> Void)?
    private var state: State = .none {
        didSet {
            didChangeState?(state)
        }
    }
    
    func getLocationInformations(location: CLLocation) {
        state = .loading
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { [weak self] (landmarks, error) in
            if let error = error {
                self?.state = .failure(error: error)
                return
            }
            
            let string = landmarks?.first?.addressDictionary?.compactMap({ (dic) -> String? in
                if let string = dic.value as? String {
                    return string
                } else {
                    return nil
                }
            }).joined(separator: ",")
            self?.state = .success(result: string ?? "" )
        }
    }
}

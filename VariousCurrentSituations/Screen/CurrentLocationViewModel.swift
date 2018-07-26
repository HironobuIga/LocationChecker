//
//  CurrentLocationViewModel.swift
//  VariousCurrentSituations
//
//  Created by iganin on 2018/07/21.
//  Copyright © 2018年 iganin. All rights reserved.
//

import CoreLocation

final class CurrentLocationViewModel: NSObject {
    enum State {
        case none, loading, success(result: CLPlacemark?), failure(error: Error?)
    }
    
    // MARK: - Property
    private var state: State = .none {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.didChangeState?(self.state)
            }
        }
    }
    private let geoCoderRequester = GeoCoderRequester()
    private let locationManager = CLLocationManager()
    var didChangeState: ((State) -> Void)?
    
    // MARK: - Life Cycle
    override init() {
        super.init()
        geoCoderRequester.didChangeState = { [weak self] state in
            guard let `self` = self else { return }
            switch state {
            case .none, .loading: break
            case .failure(let error): self.state = .failure(error: error)
            case .success(let result): self.state = .success(result: result)
            }
        }
        locationManager.delegate = self
    }
    
    // MARK: - Method
    func fetchLocationAndLocationName() {
        state = .loading
        locationManager.requestLocation()
    }
    
}

// MARK: - Private Method
private extension CurrentLocationViewModel {
    private func fetchLocationName(_ location: CLLocation?) {
        guard let location = location else { return }
        geoCoderRequester.getLocationInformations(location: location)
    }
}

// MARK: - CLLocationManagerDelegate
extension CurrentLocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse: break // 許可済み
        case .denied, .restricted: break // 許可していない
        case .notDetermined: locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        fetchLocationName(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        state = .failure(error: error)
        print(error.localizedDescription)
    }
}

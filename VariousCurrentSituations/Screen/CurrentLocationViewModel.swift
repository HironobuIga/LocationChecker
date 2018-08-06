//
//  CurrentLocationViewModel.swift
//  VariousCurrentSituations
//
//  Created by iganin on 2018/07/21.
//  Copyright © 2018年 iganin. All rights reserved.
//

import CoreLocation

final class CurrentLocationViewModel: NSObject {
    enum State<ObjectType> {
        case none, loading, success(result: ObjectType?), failure(error: Error?)
    }
    
    // MARK: - Property
    private var state: State<CLPlacemark> = .none {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.didChangeState?(self.state)
            }
        }
    }
    private var fetchLocationState: State<CLLocation> = .none {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.didChangeFetchLocationState?(self.fetchLocationState)
            }
        }
    }
    private let geoCoderRequester = GeoCoderRequester()
    private let locationManager = CLLocationManager()
    var didChangeState: ((State<CLPlacemark>) -> Void)?
    var didChangeFetchLocationState: ((State<CLLocation>) ->  Void)?
    var location: CLLocation?
    var placemarks = [CLPlacemark]()
    
    // MARK: - Life Cycle
    override init() {
        super.init()
        
        geoCoderRequester.didChangeState = { [weak self] state in
            guard let `self` = self else { return }
            switch state {
            case .none: break
            case .loading: self.state = .loading
            case .failure(let error): self.state = .failure(error: error)
            case .success(let result):
                if let result = result {
                    self.placemarks.append(result)
                    self.state = .success(result: result)
                } else {
                    self.state = .failure(error: nil)
                }
            }
        }
        locationManager.delegate = self
    }
    
    // MARK: - Method
    func fetchLocationName(_ location: CLLocation?) {
        guard let location = location else { return }
        geoCoderRequester.getLocationInformations(location: location)
    }
    
    func fetchCurrentLocation() {
        fetchLocationState = .loading
        locationManager.requestLocation()
    }
    
}

// MARK: - Private Method
private extension CurrentLocationViewModel {
    
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
        self.location = locations.first
        guard let location = locations.first else {
            fetchLocationState = .failure(error: nil)
            return
        }
        fetchLocationState = .success(result: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.location = nil
        fetchLocationState = .failure(error: error)
        print(error.localizedDescription)
    }
}

//
//  ViewController.swift
//  VariousCurrentSituations
//
//  Created by 伊賀裕展 on 2018/07/18.
//  Copyright © 2018年 伊賀裕展. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - Property
    var locationManager: CLLocationManager!

    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    // MARK: - Method

}

// MARK: - Private Method
private extension ViewController {
    
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse: break // 許可済み
        case .denied, .restricted: break // 許可していない
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}

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
    // MARK: - IBOutlet
    @IBOutlet private weak var locationMameLabel: UILabel!
    
    @IBOutlet weak var updateButton: UIButton! {
        didSet {
            updateButton.clipsToBounds = true
            updateButton.layer.cornerRadius = 4.0
        }
    }
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied, .notDetermined, .restricted:
            return
        }
    }
    
    // MARK: - Property
    var locationManager: CLLocationManager!
    var locationName: String? {
        didSet {
            // Labelの更新
            locationMameLabel.text = locationName
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - Method

}

// MARK: - Private Method
private extension ViewController {
    private func getLocationName(location: CLLocation, completionHandler: @escaping (String?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (landmarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let string = landmarks?.first?.addressDictionary?.compactMap({ (dic) -> String? in
                if let string = dic.value as? String {
                    return string
                } else {
                    return nil
                }
            }).joined(separator: ",")
            return completionHandler(string)
        }
    }
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
        guard let location = locations.first else { return }
        getLocationName(location: location) { [weak self] locationName in
            guard let `self` = self else { return }
            self.locationName = locationName
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

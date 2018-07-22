//
//  ViewController.swift
//  VariousCurrentSituations
//
//  Created by iganin on 2018/07/18.
//  Copyright © 2018年 iganin. All rights reserved.
//

import UIKit
import CoreLocation

final class CurrentLocationViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var locationMameLabel: UILabel!
    @IBOutlet private weak var updateButton: UIButton! {
        didSet {
            updateButton.clipsToBounds = true
            updateButton.layer.cornerRadius = 4.0
        }
    }
    
    @IBAction private func updateButtonTapped(_ sender: UIButton) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse: viewModel.fetchLocationAndLocationName()
        case .denied, .notDetermined, .restricted: return
        }
    }
    
    // MARK: - Property
    let viewModel = CurrentLocationViewModel()
    var locationName: String? {
        didSet {
            locationMameLabel.text = locationName // Labelの更新
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.didChangeState = { [weak self] state in
            guard let `self` = self else { return }
            switch state {
            case .none: break
            case .loading: break // loadingの表示
            case .success(let string):
                // loadingの非表示
                self.locationName = string
            case .failure(_):
                // loadingの非表示
                let title = "エラー"
                let message = "位置情報の取得に失敗しました"
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

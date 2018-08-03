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
    
    @IBOutlet private weak var addressInfoBaseView: UIView!
    @IBOutlet private weak var updateButton: UIButton! {
        didSet {
            updateButton.clipsToBounds = true
            updateButton.layer.cornerRadius = 4.0
        }
    }
    
    @IBOutlet private weak var latitudeTextField: UITextField!
    @IBOutlet private weak var longitudeTextField: UITextField!
    
    @IBAction private func updateButtonTapped(_ sender: UIButton) {
        guard let latitudeString = latitudeTextField.text,
            let longitudeString = longitudeTextField.text,
            let latitude = Double(latitudeString),
        let longitude = Double(longitudeString) else {
            let alert = UIAlertController(title: "エラー", message: "緯度・経度が入力されていません", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let location = CLLocation(latitude: latitude, longitude: longitude)
        viewModel.fetchLocationName(location)
    }
    
    @IBAction private func didTouchUpInsideCurrentPositionButton(_ sender: UIBarButtonItem) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse: viewModel.fetchCurrentLocation()
        case .denied, .notDetermined, .restricted: return
        }
    }
    
    // MARK: - Property
    let viewModel = CurrentLocationViewModel()
    let addressInfoView = AddressInfoView.instantiateFromNib()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpObservable()
    }
}

// MARK: - Private Method
private extension CurrentLocationViewController {
    func setUpView() {
        addressInfoBaseView.addSubview(addressInfoView)
        addressInfoView.edges(to: addressInfoBaseView)
    }
    
    func setUpObservable() {
        viewModel.didChangeFetchLocationState = { [weak self] state in
            guard let `self` = self else { return }
            switch state {
            case .none: break
            case .loading: self.navigationController?.view.showLoading()
            case .success(let location):
                self.navigationController?.view.hideLoading()
                if let location = location {
                    self.latitudeTextField.text = String(location.coordinate.latitude)
                    self.longitudeTextField.text = String(location.coordinate.longitude)
                }
            case .failure(_):
                self.navigationController?.view.hideLoading()
                let title = "エラー"
                let message = "位置情報の取得に失敗しました"
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
        viewModel.didChangeState = { [weak self] state in
            guard let `self` = self else { return }
            switch state {
            case .none: break
            case .loading:
                self.view.showLoading()
            case .success(let result):
                self.view.hideLoading()
                self.addressInfoView.placemark = result
            case .failure(_):
                self.view.hideLoading()
                let title = "エラー"
                let message = "位置名称の取得に失敗しました"
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

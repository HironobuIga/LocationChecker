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
    
    @IBOutlet private weak var updateButton: UIButton! {
        didSet {
            updateButton.clipsToBounds = true
            updateButton.layer.cornerRadius = 4.0
        }
    }
    
    @IBOutlet private weak var latitudeTextField: UITextField! {
        didSet {
            let bar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
            bar.barStyle = .default
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(didTouchUpInsideDoneButton(_:)))
            bar.items = [spacer, doneButton]
            latitudeTextField.inputAccessoryView = bar
        }
    }
    
    @IBOutlet private weak var longitudeTextField: UITextField! {
        didSet {
            let bar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
            bar.barStyle = .default
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(didTouchUpInsideDoneButton(_:)))
            bar.items = [spacer, doneButton]
            longitudeTextField.inputAccessoryView = bar
        }
    }
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            CurrentLocationTableViewCell.registerNibTo(tableView)
            tableView.estimatedRowHeight = UITableViewAutomaticDimension
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    
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
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpObservable()
    }
}

// MARK: - Private Method
private extension CurrentLocationViewController {
    func setUpView() { }
    
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
            case .success(_):
                self.view.hideLoading()
                self.tableView.reloadData()
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
    
    @objc func didTouchUpInsideDoneButton(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource
extension CurrentLocationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
//        return viewModel.placemarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrentLocationTableViewCell.reuseIdentifier, for: indexPath) as! CurrentLocationTableViewCell
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CurrentLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

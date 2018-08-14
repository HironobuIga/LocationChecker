//
//  CurrentLocationTableViewCell.swift
//  VariousCurrentSituations
//
//  Created by iganin on 2018/08/10.
//  Copyright © 2018年 iganin. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationTableViewCell: UITableViewCell, ViewReusable, NibLoadable {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var postalCodeLabel: UILabel!
    @IBOutlet private weak var addressNameLabel: UILabel!
    @IBAction private func didTouchUpInsideShareButton(_ sender: UIButton) {
        // ActivityControllerへのつなぎ
        didTouchUpInsideShareButton?()
    }
    
    
    // MARK: - Property
    var placeMark: CLPlacemark? {
        didSet {
            guard let placeMark = placeMark else { return }
            postalCodeLabel.text = placeMark.postalCode
            var address = placeMark.administrativeArea ?? ""
            address.append(placeMark.locality ?? "")
            address.append(placeMark.name ?? "")
            addressNameLabel.text = address
        }
    }
    
    var didTouchUpInsideShareButton: (() -> Void)?
    var shareInformationString: String {
        var shareInfoString = postalCodeLabel.text ?? ""
        shareInfoString.append(addressNameLabel.text ?? "")
        return shareInfoString
    }
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        baseView.layer.cornerRadius = 10.0
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        baseView.layer.shadowOpacity = 0.3
        baseView.layer.shadowRadius = 4.0
        baseView.layer.shadowPath = UIBezierPath(rect: baseView.bounds).cgPath
        baseView.layer.shouldRasterize = true;
        baseView.layer.rasterizationScale = UIScreen.main.scale
    }
}

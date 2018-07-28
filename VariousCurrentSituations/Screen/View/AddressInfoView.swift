//
//  AddressInfoView.swift
//  VariousCurrentSituations
//
//  Created by iganin on 2018/07/25.
//  Copyright © 2018年 iganin. All rights reserved.
//

import UIKit
import CoreLocation

final class AddressInfoView: UIView, NibLoadable {
    @IBOutlet private weak var addressNumberLabel: UILabel!
    
    var placemark: CLPlacemark? {
        didSet {
            addressNumberLabel.text = placemark?.postalCode
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 16.0
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1.0
    }
}

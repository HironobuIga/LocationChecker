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
    @IBOutlet private weak var spotImageView: UIImageView! {
        didSet {
            spotImageView.tintColor = .gray
        }
    }
    
    @IBOutlet private weak var baseView: UIView!
    
    // MARK: - Property
    var placeMark: CLPlacemark? {
        didSet {
            postalCodeLabel.text = placeMark?.postalCode
        }
    }
    @IBOutlet private weak var postalCodeLabel: UILabel!
    
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

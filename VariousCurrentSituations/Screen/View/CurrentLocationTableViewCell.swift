//
//  CurrentLocationTableViewCell.swift
//  VariousCurrentSituations
//
//  Created by iganin on 2018/08/10.
//  Copyright © 2018年 iganin. All rights reserved.
//

import UIKit

class CurrentLocationTableViewCell: UITableViewCell, ViewReusable, NibLoadable {
    
    @IBOutlet private weak var spotImageView: UIImageView! {
        didSet {
            spotImageView.tintColor = .gray
        }
    }
    
    @IBOutlet private weak var baseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        baseView.layer.cornerRadius = 10.0
        baseView.clipsToBounds = true
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOffset = .zero
        baseView.layer.shadowOpacity = 0.3
        baseView.layer.shadowRadius = 4.0
        baseView.layer.shadowPath = UIBezierPath(rect: baseView.bounds).cgPath
        baseView.layer.shouldRasterize = true;
        baseView.layer.rasterizationScale = UIScreen.main.scale
    }
}

//
//  CurrentLocationTableViewCell.swift
//  VariousCurrentSituations
//
//  Created by iganin on 2018/08/07.
//  Copyright © 2018年 iganin. All rights reserved.
//

import UIKit

class CurrentLocationTableViewCell: UITableViewCell, NibLoadable, ViewReusable {

    @IBOutlet private weak var baseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        baseView.layer.cornerRadius = 6.0
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOffset = CGSize(width: baseView.frame.size.width, height: 10)
        baseView.layer.shadowOpacity = 0.2
        baseView.layer.shadowRadius = 4
    }
}

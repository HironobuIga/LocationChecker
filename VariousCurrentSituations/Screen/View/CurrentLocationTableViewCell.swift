//
//  CurrentLocationTableViewCell.swift
//  VariousCurrentSituations
//
//  Created by iganin on 2018/08/10.
//  Copyright © 2018年 iganin. All rights reserved.
//

import UIKit

class CurrentLocationTableViewCell: UITableViewCell, ViewReusable, NibLoadable {
    @IBOutlet private weak var baseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

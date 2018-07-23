//
//  ViewLoadable.swift
//  VariousCurrentSituations
//
//  Created by iganin on 2018/07/19.
//  Copyright © 2018年 iganin. All rights reserved.
//

import UIKit

protocol Loadable {
    func showLoading()
    func hideLoading()
}

extension UIView: Loadable {
    var loadingViewTag: Int { return 9999999 }
    
    func showLoading() {
        self.isUserInteractionEnabled = false
        
        let overLayView = UIView(frame: self.frame)
        overLayView.backgroundColor = UIColor.black
        overLayView.alpha = 0.4
        overLayView.tag = loadingViewTag
        self.addSubview(overLayView)
        
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        overLayView.addSubview(indicatorView)
        indicatorView.hidesWhenStopped = true
        indicatorView.center = self.center
        indicatorView.startAnimating()
    }
    
    func hideLoading() {
        self.isUserInteractionEnabled = true
        
        if let overLayView = self.viewWithTag(loadingViewTag) {
            overLayView.removeFromSuperview()
        }
    }
}

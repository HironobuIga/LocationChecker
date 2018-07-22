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
        let overLayView = UIView(frame: self.frame)
        overLayView.backgroundColor = UIColor.black
        overLayView.tag = loadingViewTag
        
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        indicatorView.centerXAnchor.constraint(equalTo: overLayView.centerXAnchor, constant: 0.0)
        indicatorView.centerYAnchor.constraint(equalTo: overLayView.centerYAnchor, constant: 0.0)
        overLayView.addSubview(indicatorView)
        
        overLayView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(overLayView)
        overLayView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0)
        overLayView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0)
        overLayView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0)
        overLayView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0)
        indicatorView.startAnimating()
    }
    
    func hideLoading() {
        if let overLayView = self.viewWithTag(loadingViewTag) {
            overLayView.removeFromSuperview()
        }
    }
}

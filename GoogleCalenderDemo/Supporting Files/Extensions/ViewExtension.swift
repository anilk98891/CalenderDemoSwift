//
//  ViewExtension.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 18/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import Foundation
import  UIKit
extension UIView {
    func viewEmptyView(bgImage: UIImage, errorMsg: String) {
        let bGImageView = UIImageView.init(image: bgImage)
        bGImageView.frame = CGRect(x: 0, y: 0, width: 100 , height: 100)
        bGImageView.center = self.center
        bGImageView.center.y -= 100
        self.addSubview(bGImageView)
        
        let textError = UILabel()
        textError.frame = CGRect(x: 0, y: 0, width: self.frame.width , height: 100)
        textError.text = errorMsg
        textError.textAlignment = .center
        textError.textColor = .black
        textError.center = self.center
        textError.center.y = self.center.y
        self.addSubview(textError)
    }
}

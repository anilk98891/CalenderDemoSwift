//
//  Indicator.swift
//  Clever&Smith
//
//  Created by Anil Kumar on 20/12/18.
//  Copyright © 2018 Busywizzy. All rights reserved.
//

import Foundation
import UIKit

public class Indicator {
    
    public static let sharedInstance = Indicator()
    var blurImg = UIImageView()
    var indicator = UIActivityIndicatorView()
    
    private init()
    {
        blurImg.frame = UIScreen.main.bounds
        blurImg.backgroundColor = UIColor.black
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha = 0.5
        indicator.style = .whiteLarge
        indicator.center = blurImg.center
        indicator.startAnimating()
        indicator.color = .black
    }
    
    func showIndicator(){
        UIApplication.shared.keyWindow?.addSubview(self.blurImg)
        UIApplication.shared.keyWindow?.addSubview(self.indicator)
    }
    func hideIndicator(){
        
        self.blurImg.removeFromSuperview()
        self.indicator.removeFromSuperview()
    }
}

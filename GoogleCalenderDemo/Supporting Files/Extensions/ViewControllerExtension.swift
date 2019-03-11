//
//  ViewControllerExtension.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 18/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
    func showAlert(withTitle title: String, message: String, completion: (() -> Void)? = nil)
    {
        let okAction = UIAlertAction(title: "Ok", style: .default){ (action) in
            completion?()
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showOkAndCancelAlert(withTitle title: String,buttonTitle :String, message: String, _ okAction: @escaping ()->Void)
    {
        let ok = UIAlertAction(title: buttonTitle, style: .default){ (action) in
            okAction()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive){ (action) in
            
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
        alertController.addAction(cancel)
        alertController.addAction(ok)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func customRightBarButton(image: UIImage){
        let rightButton = UIButton() //Custom back Button
        rightButton.frame = CGRect(x: 0, y: 0, width: 42, height: 36)
        rightButton.setTitle(title, for: .normal)
        rightButton.setImage(image, for: .normal)
        rightButton .addTarget(self, action: #selector(self.btnDoneClicked(sender:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = rightButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = 0;
        self.navigationItem.setRightBarButtonItems([negativeSpacer, rightBarButton], animated: false)
    }
    
    @objc func btnDoneClicked(sender:UIButton)
    { //Dne Button
    }
    
    func getLastSyncTime(completion:(Bool)->()){
        if let timelastsync = UserDefaults.standard.object(forKey: userDefaultsConstants.kLastSyncTime) as? Date {
            if Int(self.timeDiffrence(time1: timelastsync, time2:Date()))! > appconfig.kSyncTime.rawValue{
                completion(true) //more than 1 hrs
            } else{
                completion(false) //less than 1hrs
            }
        } else {
            completion(true)
        }
    }
    
    func timeDiffrence (time1 : Date,time2 : Date) -> String {
        let difference = Calendar.current.dateComponents([.hour, .minute], from: time1, to: time2)
        let hoursInmint = difference.hour ?? 0
        let time = hoursInmint * 60 + difference.minute!
        return "\(time)"
    }
}

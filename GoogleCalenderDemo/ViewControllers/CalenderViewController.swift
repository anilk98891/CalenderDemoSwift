//
//  CalenderViewController.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 18/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import UIKit
import ObjectMapper
import GoogleSignIn

class CalenderViewController: UIViewController {
    @IBOutlet weak var buttonOutletTasks: UIButton!
    @IBOutlet weak var viewMain: UIView!
    //MARK:- variables
    var calenderEvents = [calenderobj]()
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        self.customRightBarButton(image: UIImage.init(named: "error") ?? UIImage())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else {
                return
            }
            self.apiCallenderSync(compeltion: {
                self.storeDataToCalender()
            })
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.viewMain.center.y -= self.viewMain.center.y + 100
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.viewMain.center = self.view.center
            })
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.viewMain.center.y -= self.viewMain.center.y + 100
        buttonOutletTasks.isUserInteractionEnabled = true
    }
    
    @IBAction func buttonActionEventsCalendar(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func buttonActionCalender(_ sender: Any) {
        self.performSegue(withIdentifier: "ViewController", sender: self)
    }
    
    @objc override func btnDoneClicked(sender:UIButton)
    { //Dne Button
        exit(0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewController"{
            let destination = segue.destination as! ViewController
            destination.calenderEvents = self.calenderEvents
            destination.title = "Calendar list"
        } else if segue.identifier == "TaskViewController"{
            let destination = segue.destination as! TaskViewController
            destination.title = "Alerts list"
        }
    }
}

//MARK:- Google calender
extension CalenderViewController {
    func storeDataToCalender() {
        switch CalenderAuth.shared.authorized() {
        case .authorized:
            self.insertOrDeleteToCalender()
            break
        case .denied:
            self.showOkAndCancelAlert(withTitle: "Google Calender", buttonTitle: "Settings", message: "You need to allow calender setting from app settings") {
                let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(settingsUrl)
            }
            break
        case .notDetermined:
            CalenderAuth.shared.eventStore.requestAccess(to: .event, completion:
                {(granted: Bool, error: Error?) -> Void in
                    if granted {
                        self.insertOrDeleteToCalender()
                    } else {
                        print("Access denied")
                        self.showOkAndCancelAlert(withTitle: "Google Calender", buttonTitle: "Ok", message: "You denied the calender setting want to enable again go to app settings") {
                        }
                    }
            })
            break
        default:
            break
        }
    }
    
    func insertOrDeleteToCalender() {
        CalenderAuth.shared.createAppCalendar(completion: { (success) in
            if success{
                LocalNotificationTrigger.shared.authorized{ (success) in
                    if !success{
                        self.showOkAndCancelAlert(withTitle: "App", buttonTitle: "Settings", message: "Your Notification not be allowed allow them.", {
                            let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
                            UIApplication.shared.open(settingsUrl)
                        })
                    }
                    LocalNotificationTrigger.shared.deleteAllNotification { (success) in
                        if success{
                            for i in self.calenderEvents {
                                workerQueue.async {
                                    CalenderAuth.shared.removeAllEventsMatchingPredicate(dict: i, completion: { success in
                                        if success{
                                            CalenderAuth.shared.insertEvent( dict: i)
                                        }
                                        else {
                                            
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            } else {
                print("calendar not created")
            }
        })
    }
}

extension CalenderViewController : GIDSignInDelegate,GIDSignInUIDelegate {
    
    //MARK:- Google Delegates
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            let userId = user.userID
            print(userId ?? "Not found")
            let token = user.authentication.accessToken
            UserDefaults.standard.setValue(token, forKey: "token")
            print(token ?? "")
            //            let fullName : String = user.profile.name
            UserDefaults.standard.setValue(token, forKey: userDefaultsConstants.authToken)
            self.performSegue(withIdentifier: "TaskViewController", sender: self)
        } else {
            print("\(error.localizedDescription)")
            buttonOutletTasks.isUserInteractionEnabled = true
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print(signIn.clientID)
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK:- Api Call
extension CalenderViewController{
    func apiCallenderSync(compeltion: @escaping ()->()) {
        
        HttpClient.getRequest(urlString: GetApiURL.kGetEvents.typeURL(), header: nil,loaderEnable: true, successBlock: { (response) in
            
            if let webServiceData = response as? Dictionary<String,Any>{
                if let data = webServiceData["items"] as? [Dictionary<String,Any>]{
                    self.calenderEvents.removeAll()
                    for dataupdate in data {
                        if let userInfoObj = Mapper<calenderobj>().map(JSONObject: dataupdate) {
                            self.calenderEvents.append(userInfoObj)
                        }
                    }
                    compeltion()
                }
            }
        }) { (error) in
            self.showAlert(withTitle: "App", message: error)
        }
    }
}

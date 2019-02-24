//
//  AppDelegate.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 18/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initialize sign-in
        self.registerForPushNotifications(application: application)
        GIDSignIn.sharedInstance().clientID = "290826560562-9j8fl9h2o1pu67ldpv3v4ejsaqhrftr0.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.scopes = ["https://www.googleapis.com/auth/calendar"]
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

//MARK:- Push Notification Delegate Methods
extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerForPushNotifications(application: UIApplication) {
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        // set the type as sound or badge
        center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            // Enable or disable features based on authorization
        }
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        // custom code to handle push while app is in the foreground
        print("\(notification.request.content.userInfo)")
        if let dict: [String : AnyObject] = notification.request.content.userInfo["aps"] as? [String : AnyObject]{
            if let alert = dict["alert"] as? Dictionary<String, AnyObject>{
                if alert["title"] as? Int == 1{
//                    if let bookingData =  dict["bookingdata"] as? Dictionary<String, AnyObject>{
//                        //self.handlePushData(dict: bookingData)
//                    }
                }else if alert["title"] as? Int == 9{
                    // self.forceFullyLogout()
                    completionHandler([.sound])
                }
                
                // for Cancel ride push
                
                if alert["body"] as? String == "booking cancelled by trucker."{
//                    if let bookingData =  dict["bookingdata"] as? Dictionary<String, AnyObject>{
//                        //  self.handlePushData(dict: bookingData)
//                    }
                }
                
                // for Accepting the Ride
                
                if alert["body"] as? String == "Your shippment has been accepted.Driver on the way."{
                    // post a notification
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AcceptRide"), object: nil, userInfo: nil)
                }
                
            }
            //   self.handlePushData(dict: dict) //Manage push data
            
        }
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
        print("\(response.notification.request.content.userInfo)")
        if let dict: [String : AnyObject] = response.notification.request.content.userInfo["aps"] as? Dictionary<String, AnyObject>{
            if let alert = dict["alert"] as? Dictionary<String, AnyObject>{
                if alert["title"] as? Int == 1{
//                    if let bookingData =  dict["bookingdata"] as? Dictionary<String, AnyObject>{
//                        //  self.handlePushData(dict: bookingData)
//                    }else if alert["title"] as? Int == 9{
//                        //   self.forceFullyLogout()
//                    }
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    center.removeAllDeliveredNotifications()
                    completionHandler()
                }
            }
        }
    }
}


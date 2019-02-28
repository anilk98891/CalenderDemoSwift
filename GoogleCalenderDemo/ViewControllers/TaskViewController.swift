//
//  TaskViewController.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 28/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import UIKit
import ObjectMapper

class TaskViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var popUpView = AlertView()
    var calendarTasks = [Task]()
    var calendarSubTasks = [SubTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else {
                return
            }
            self.apiCallenderTaskSync {
                for (index,_) in self.calendarTasks.enumerated(){
                    CalenderAuth.shared.taskId = self.calendarTasks[index].id ?? ""
                    self.apiCallenderSubTaskSync(index: index) {
                        print(self.calendarTasks)
                        self.tableView.reloadData()
                        //                        self.storeDataToCalender()
                    }
                }
            }
        }
    }
    
    func eventInfo(indexpath : IndexPath) {
        
        self.popUpView.frame =  CGRect.init(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0)
        self.popUpView.viewCenter.alpha = 0
        self.popUpView.viewCenter.isHidden = true
        self.popUpView.completionBlock = { [weak self] () in
            guard let strongSelf = self else {return}
            strongSelf.popUpView.removeFromSuperview()
        }
        self.popUpView.calendarTasks = calendarTasks[indexpath.section].subTask[indexpath.row]
        DispatchQueue.main.async {
            self.popUpView.updateViewTasks()
            self.addSubView()
            UIView.animate(withDuration: 0.4) {
                self.popUpView.frame =  CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

                self.popUpView.center = self.view.center
                DispatchQueue.main.asyncAfter(deadline: .now()+0.39, execute: {
                    self.popUpView.viewCenter.isHidden = false
                    self.popUpView.viewCenter.alpha = 1
                })
            }
        }
    }
    
    func addSubView() {
        self.view.addSubview(self.popUpView)
        self.view.bringSubviewToFront(popUpView)
    }
    
}

extension TaskViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return calendarTasks.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarTasks[section].subTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectionStyle = .none
        
        let labelDate = cell?.viewWithTag(10) as? UILabel
        labelDate?.text = calendarTasks[indexPath.section].subTask[indexPath.row].updated?.DateFromString(format: DateFormat.dateTimeUTC2, convertedFormat: DateFormat.dateMonth)
        let labelTime = cell?.viewWithTag(11) as? UILabel
        labelTime?.text = calendarTasks[indexPath.section].subTask[indexPath.row].updated?.DateFromString(format: DateFormat.dateTimeUTC2, convertedFormat: DateFormat.dayDate)
        let labelTitle = cell?.viewWithTag(12) as? UILabel
        labelTitle?.text = calendarTasks[indexPath.section].subTask[indexPath.row].title
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.eventInfo(indexpath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.size.width, height: 50))
        view.backgroundColor = UIColor.init().getBGTaskColor()
        let label = UILabel.init(frame: CGRect.init(x: 20, y: 15, width: self.view.frame.size.width - 40, height: 25))
        label.text = calendarTasks[section].title ?? ""
        label.center.x = tableView.center.x
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if calendarTasks[section].subTask.count == 0{
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.size.width, height: 50))
            view.backgroundColor = .lightGray
            let label = UILabel.init(frame: CGRect.init(x: 20, y: -50, width: self.view.frame.size.width - 40, height: 25))
            label.text = "No task has been found"
            label.center.x = tableView.center.x
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
            label.frame = CGRect.init(x: 20, y: 50, width: self.view.frame.size.width - 40, height: 25)
            view.addSubview(label)
            return view
        }else{
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if calendarTasks[section].subTask.count == 0{
            return 140
        }
        return 0
    }
}

//extension TaskViewController {
//    func storeDataToCalender() {
//        switch CalenderAuth.shared.authorized() {
//        case .authorized:
//            self.insertOrDeleteToCalender()
//            break
//        case .denied:
//            self.showOkAndCancelAlert(withTitle: "Google Calender", buttonTitle: "Settings", message: "You need to allow calender setting from app settings") {
//                let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
//                UIApplication.shared.open(settingsUrl)
//            }
//            break
//        case .notDetermined:
//            CalenderAuth.shared.eventStore.requestAccess(to: .event, completion:
//                {(granted: Bool, error: Error?) -> Void in
//                    if granted {
//                        self.insertOrDeleteToCalender()
//                    } else {
//                        print("Access denied")
//                        self.showOkAndCancelAlert(withTitle: "Google Calender", buttonTitle: "Ok", message: "You denied the calender setting want to enable again go to app settings") {
//                        }
//                    }
//            })
//            break
//        default:
//            break
//        }
//    }
//
//    func insertOrDeleteToCalender() {
//        CalenderAuth.shared.createAppCalendar(completion: { (success) in
//            if success{
//                LocalNotificationTrigger.shared.authorized{ (success) in
//                    if !success{
//                        self.showOkAndCancelAlert(withTitle: "App", buttonTitle: "Settings", message: "Your Notification not be allowed allow them.", {
//                            let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
//                            UIApplication.shared.open(settingsUrl)
//                        })
//                    }
//                    LocalNotificationTrigger.shared.deleteAllNotification { (success) in
//                        if success{
//                            for i in self.calendarTasks {
//                                for j in i.subTask{
//                                    workerQueue.async {
//                                        CalenderAuth.shared.removeAllEventsMatchingPredicate(dict: nil, dictTasks: j, completion: { success in
//                                            if success{
//                                                CalenderAuth.shared.insertEvent( dict: nil, dictTask: j)
//                                            }
//                                            else {
//
//                                            }
//                                        })
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            } else {
//                print("calendar not created")
//            }
//        })
//    }
//}
extension TaskViewController{
    func apiCallenderTaskSync(compeltion: @escaping ()->()) {
        HttpClient.getRequest(urlString: GetApiURL.kGetTasks.typeURL(), header: true,loaderEnable: true, successBlock: { (response) in
            
            if let webServiceData = response as? Dictionary<String,Any>{
                if let data = webServiceData["items"] as? [Dictionary<String,Any>]{
                    
                    
                    self.calendarTasks.removeAll()
                    for dataupdate in data {
                        if let userInfoObj = Mapper<Task>().map(JSONObject: dataupdate) {
                            self.calendarTasks.append(userInfoObj)
                        }
                    }
                    compeltion()
                } else{
                    self.view.viewEmptyView(bgImage: UIImage.init(named: "calendar") ?? UIImage(), errorMsg: "No Task in the list.")
                }
            }
        }) { (error) in
            self.showAlert(withTitle: "App", message: error)
        }
    }
    
    func apiCallenderSubTaskSync(index: Int, compeltion: @escaping ()->()) {
        HttpClient.getRequest(urlString: GetApiURL.kGetSubTasks.typeURL(), header: true,loaderEnable: true, successBlock: { (response) in
            
            if let webServiceData = response as? Dictionary<String,Any>{
                if let data = webServiceData["items"] as? [Dictionary<String,Any>]{
                    self.calendarSubTasks.removeAll()
                    for dataupdate in data {
                        if let userInfoObj = Mapper<SubTask>().map(JSONObject: dataupdate) {
                            self.calendarSubTasks.append(userInfoObj)
                        }
                    }
                    self.calendarTasks[index].subTask = self.calendarSubTasks
                    self.calendarSubTasks.removeAll()
                    compeltion()
                }else {
                    //No subtask
                    compeltion()
                }
            }
        }) { (error) in
            self.showAlert(withTitle: "App", message: error)
        }
    }
}

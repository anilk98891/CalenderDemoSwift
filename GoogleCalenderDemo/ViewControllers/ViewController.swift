//
//  ViewController.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 18/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import UIKit
import ObjectMapper

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var popUpView = AlertView()
    var calenderEvents = [calenderobj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiComponents()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func uiComponents() {
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func eventInfo(indexpath : IndexPath) {
        self.popUpView.frame =  CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.popUpView.center = self.view.center
        self.popUpView.completionBlock = { [weak self] () in
            guard let strongSelf = self else {return}
            strongSelf.popUpView.removeFromSuperview()
        }
        self.popUpView.calenderEvents = calenderEvents[indexpath.row]
        DispatchQueue.main.async {
            self.popUpView.updateView()
            self.addSubView()
        }
    }
    
    func addSubView() {
        self.view.addSubview(self.popUpView)
        self.view.bringSubviewToFront(popUpView)
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calenderEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectionStyle = .none
        let labelDate = cell?.viewWithTag(10) as? UILabel
        labelDate?.text = calenderEvents[indexPath.row].updated?.start?.DateFromString(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.dateMonth)
        let labelTime = cell?.viewWithTag(11) as? UILabel
        labelTime?.text = calenderEvents[indexPath.row].updated?.start?.DateFromString(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.dayDate)
        let labelTitle = cell?.viewWithTag(12) as? UILabel
        labelTitle?.text = calenderEvents[indexPath.row].summary
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.eventInfo(indexpath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}
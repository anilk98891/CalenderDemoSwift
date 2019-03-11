//
//  AlertView.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 18/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var imageViewCalendarPopUp: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttOnCancel: UIButton!
    var completionBlock : completionHandlerButton?
    var calenderEvents : calenderobj?
    var calendarTasks : SubTask?
    
    //    MARK:- view life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    @IBAction func buttonActionClose(_ sender: Any) {
        guard let cb = self.completionBlock else {return}
        cb()
    }
    
    func loadViewFromNib() {
        let view = UINib(nibName: "AlertViews", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundColor =  .white
        self.buttOnCancel.layer.borderColor = UIColor.init(named: "gray")?.cgColor
        self.buttOnCancel.layer.borderWidth = 1
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addSubview(view);
    }
    
    func updateViewTasks() {
        imageViewCalendarPopUp.image = UIImage.init(named: "events")
        let taskdate = calendarTasks?.due ?? calendarTasks?.updated ?? ""
        self.labelDate.text = taskdate.DateFromString(format: DateFormat.dateTimeUTC2, convertedFormat: DateFormat.dateNow)
        self.labelTime.isHidden = true
        self.labelTitle.text = calendarTasks?.title
        self.labelDescription.text = calendarTasks?.notes
    }
    
    func updateView() {
        imageViewCalendarPopUp.image = UIImage.init(named: "calendar")
        self.labelDate.text = calenderEvents?.updated?.start?.DateFromString(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.dateNow)
        self.labelTime.text = calenderEvents?.updated?.start?.DateFromString(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.timeAmPM)
        self.labelTitle.text = calenderEvents?.summary
        self.labelDescription.text = calenderEvents?.description
    }
}

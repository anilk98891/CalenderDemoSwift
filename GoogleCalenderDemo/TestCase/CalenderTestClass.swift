//
//  CalenderTestClass.swift
//  GoogleCalenderDemoTests
//
//  Created by Anil Kumar on 24/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import XCTest
@testable import GoogleCalenderDemo

class CalenderTestClass: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDateFormat() {
        let str = "2019-02-21T13:30:00+05:30".DateFromString(format: DateFormat.dateTimeUTC, convertedFormat: DateFormat.day)
        XCTAssertEqual(str, "21")
    }
    
    func testErrorCode(){
        let str = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = str.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.viewWillLayoutSubviews()
        let data = ErrorUtility.errorMessageFor(errorcode: 400)
        //vc.calenderEvents.append(userInfoObj!)
        XCTAssertEqual(data, "Bad Request")
        
    }
    
}

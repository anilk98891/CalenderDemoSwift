//
//  Networking.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 18/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import Foundation
import Alamofire

class HttpClient
{
    static var cookieName = Dictionary<String,String>()
    static var requiredAuth = false
    
    static var headers: [String:String]
    {
        var dict = ["Content-Type": "application/json"]
        if requiredAuth {
            if let token = UserDefaults.standard.value(forKey: userDefaultsConstants.authClientAccessToken) as? String
            {
                dict["Authorization"] = "OAuth " + token
            }
        }
        return dict
    }
    
    static var headersForImageUpload: [String:String]
    {
        //        var str = "\"filename.jpg\""
        //        str = str.replacingOccurrences(of: "\", with: "")
        let dict = ["Content-Type": "application/octet-stream"]
        //        let str = "file; filename=\"filename.jpg\""
        
        return dict
    }
    
    class func getRequest( urlString: String,header : Bool? = false,loaderEnable : Bool? = true,  successBlock :@escaping (_ response :AnyObject)->Void, errorBlock:@escaping (_ errorMessage :String)->Void
        )
    {
        requiredAuth = header ?? false
        print(headers)
        if loaderEnable! {
            DispatchQueue.main.async( execute: {
                Indicator.sharedInstance.showIndicator()
            })
        }
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if(error == nil)
            {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? AnyObject
                    guard let _ = responseJSON else {
                        DispatchQueue.main.async {
                            errorBlock("Exception occured")
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        Indicator.sharedInstance.hideIndicator()
                        
                        successBlock(responseJSON!)
                    }
                    
                }
                catch
                {
                    let responseString = String(data: data!, encoding: .utf8)
                    print("raw response: \(responseString ?? "")")
                    
                    DispatchQueue.main.async {
                        Indicator.sharedInstance.hideIndicator()
                        successBlock(responseString as AnyObject)
                    }
                }
            }
            else
            {
                let msg = ErrorUtility.errorMessageFor(response: urlResponse as! HTTPURLResponse?, error: error as NSError?)
                
                DispatchQueue.main.async {
                    Indicator.sharedInstance.hideIndicator()
                    errorBlock(msg)
                }
            }
        }
        task.resume()
    }
    
    
    class func postRequest( urlString: String, requestData: [String:Any]?,headerRequired: Bool? = false, successBlock: @escaping (_ response: AnyObject)->Void, errorBlock: @escaping (_ errorMessage :String)->Void )
    {
        requiredAuth = headerRequired ?? false
        DispatchQueue.main.async( execute: {
            Indicator.sharedInstance.showIndicator()
        })
        var request = URLRequest(url: URL(string: urlString)!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        if let _ = requestData
        {
            request.httpBody = try! JSONSerialization.data(withJSONObject: requestData as Any, options: .prettyPrinted)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if(error == nil)
            {
                let msg = ErrorUtility.errorMessageFor(response: urlResponse as! HTTPURLResponse?, error: error as NSError?)
                if msg == "204" {
                    successBlock(msg as AnyObject)
                    return
                }
                
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? AnyObject
                    
                    guard let _ = responseJSON else {
                        DispatchQueue.main.async {
                            errorBlock("Exception occured")
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        if msg == "success" {
                            successBlock(responseJSON!)
                        } else {
                            let msg = ErrorUtility.errorMessageFor(response: urlResponse as! HTTPURLResponse?, error: error as NSError?)
                            
                            DispatchQueue.main.async {
                                errorBlock(msg)
                            }
                        }
                    }
                }
                catch
                {
                    let responseString = String(data: data!, encoding: .utf8)
                    print("raw response: \(responseString ?? "")")
                    
                    DispatchQueue.main.async {
                        errorBlock("Exception occured")
                    }
                }
            }
            else
            {
                let msg = ErrorUtility.errorMessageFor(response: urlResponse as! HTTPURLResponse?, error: error as NSError?)
                
                DispatchQueue.main.async {
                    errorBlock(msg)
                }
            }
        }
        
        task.resume()
    }
    
    class func patchRequest( urlString: String, requestData: [String:Any]?, successBlock: @escaping (_ response: AnyObject)->Void, errorBlock: @escaping (_ errorMessage :String)->Void )
    {
        var request = URLRequest(url: URL(string: urlString)!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "PATCH"
        
        if let _ = requestData
        {
            request.httpBody = try! JSONSerialization.data(withJSONObject: requestData as Any, options: .prettyPrinted)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            
            if(error == nil)
            {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? AnyObject
                    guard let _ = responseJSON else {
                        DispatchQueue.main.async {
                            errorBlock("Exception occured")
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        successBlock(responseJSON!)
                    }
                }
                catch
                {
                    DispatchQueue.main.async {
                        errorBlock("Exception occured")
                    }
                }
            }
            else
            {
                let msg = ErrorUtility.errorMessageFor(response: urlResponse as! HTTPURLResponse?, error: error as NSError?)
                
                DispatchQueue.main.async {
                    errorBlock(msg)
                }
            }
        }
        
        task.resume()
    }
    
    class func putRequest( urlString: String, requestData: [String:Any]?, successBlock: @escaping (_ response: AnyObject)->Void, errorBlock: @escaping (_ errorMessage :String)->Void )
    {
        var request = URLRequest(url: URL(string: urlString)!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "PUT"
        
        if let _ = requestData
        {
            request.httpBody = try! JSONSerialization.data(withJSONObject: requestData as Any, options: .prettyPrinted)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            
            if(error == nil)
            {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? AnyObject
                    guard let _ = responseJSON else {
                        DispatchQueue.main.async {
                            errorBlock("Exception occured")
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        successBlock(responseJSON!)
                    }
                }
                catch
                {
                    DispatchQueue.main.async {
                        errorBlock("Exception occured")
                    }
                }
            }
            else
            {
                let msg = ErrorUtility.errorMessageFor(response: urlResponse as! HTTPURLResponse?, error: error as NSError?)
                
                DispatchQueue.main.async {
                    errorBlock(msg)
                }
            }
        }
        
        task.resume()
    }
    
    class func deleteRequest( urlString: String, requestData: [String:Any]?, successBlock: @escaping (_ response: AnyObject)->Void, errorBlock: @escaping (_ errorMessage :String)->Void )
    {
        var request = URLRequest(url: URL(string: urlString)!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "DELETE"
        
        if let _ = requestData
        {
            request.httpBody = try! JSONSerialization.data(withJSONObject: requestData as Any, options: .prettyPrinted)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            
            if(error == nil)
            {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? AnyObject
                    guard let _ = responseJSON else {
                        DispatchQueue.main.async {
                            errorBlock("Exception occured")
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        successBlock(responseJSON!)
                    }
                }
                catch
                {
                    DispatchQueue.main.async {
                        errorBlock("Exception occured")
                    }
                }
            }
            else
            {
                let msg = ErrorUtility.errorMessageFor(response: urlResponse as! HTTPURLResponse?, error: error as NSError?)
                
                DispatchQueue.main.async {
                    errorBlock(msg)
                }
            }
        }
        
        task.resume()
    }
    
    class func uploadRequest( urlString: String, requestData: [String:Any]?, image: UIImage, successBlock: @escaping (_ response: AnyObject)->Void, errorBlock: @escaping (_ errorMessage :String)->Void )
    {
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "PUT"
        
        if let _ = requestData
        {
            request.httpBody = try! JSONSerialization.data(withJSONObject: requestData as Any, options: .prettyPrinted)
        }
        
    }
    
    class func uploadpostRequest( urlString: String, image: UIImage, successBlock: @escaping (_ response: AnyObject)->Void, errorBlock: @escaping (_ errorMessage :String)->Void )
    {
        //        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
        //            return
        //        }
        var request = URLRequest(url: URL(string: urlString)!)
        request.allHTTPHeaderFields = headersForImageUpload
        request.httpMethod = "POST"
        print(headersForImageUpload)
        // request.httpBody =  imageData
        
        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            
            if(error == nil)
            {
                let msg = ErrorUtility.errorMessageFor(response: urlResponse as! HTTPURLResponse?, error: error as NSError?)
                if msg == "204" {
                    successBlock(msg as AnyObject)
                }
                
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? AnyObject
                    
                    guard let _ = responseJSON else {
                        DispatchQueue.main.async {
                            errorBlock("Exception occured")
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        successBlock(responseJSON!)
                    }
                }
                catch
                {
                    let responseString = String(data: data!, encoding: .utf8)
                    print("raw response: \(responseString ?? "")")
                    
                    DispatchQueue.main.async {
                        errorBlock("Exception occured")
                    }
                }
            }
            else
            {
                let msg = ErrorUtility.errorMessageFor(response: urlResponse as! HTTPURLResponse?, error: error as NSError?)
                
                DispatchQueue.main.async {
                    errorBlock(msg)
                }
            }
        }
        
        task.resume()
    }
}

//
//  UrlSession.swift
//  UTOO
//
//  Created by Dexter on 29/09/15.
//  Copyright © 2015 Strobilanthes. All rights reserved.
//

import UIKit

// service call result Success failure enum
enum Result<response, error> {
    case Success(response)
    case Failure(error)
}

typealias Closure = (result: Result<NSDictionary!, NSError>) -> () // service call completion closure

class UrlSession: NSObject {

    class var sharedInstance: UrlSession {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: UrlSession? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = UrlSession()
        }
        return Static.instance!
    }
    
    func connectWithUrl(url : NSURL, params : Dictionary<String, AnyObject>?, closure : Closure)
    {
        print("URL    " + "\(url)")
        print("POSTBODY     " + "\(params)")
        let request = NSMutableURLRequest(URL:url)
        let session = NSURLSession.sharedSession()
       
        if let postBody = params
        {
          request.HTTPMethod = "POST"
          do
          {
            let jsonData = try  NSJSONSerialization.dataWithJSONObject(postBody, options: NSJSONWritingOptions())
            let myJsonData : String = NSString(bytes: jsonData.bytes, length: jsonData.length, encoding: NSUTF8StringEncoding) as! String
            print(myJsonData)
            
            request.HTTPBody = myJsonData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
          }
          catch let error as NSError
          {
              print("JSON ERROR 1     " + error.localizedDescription)
              closure(result: Result.Failure(error))
              return
          }
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let dataTask : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> () in
             dispatch_async(dispatch_get_main_queue(), {
            if error == nil
            {
              do
              {
                  let jsonResult : NSDictionary? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                  closure(result: Result.Success(jsonResult))
              }
              catch let error as NSError
              {
                  closure(result: Result.Failure(error))
                  print("JSON ERROR 2     " + error.description)
              }
            }
            else
              {
                closure(result: Result.Failure(error!))
                print("SERVER ERROR     " + error!.localizedDescription)
              }
        })
     })
        dataTask.resume()
    }
    
}

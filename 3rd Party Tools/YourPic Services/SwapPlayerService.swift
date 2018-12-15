//
//  SwapPlayerService.swift
//  YourPick
//
//  Created by Krishna-Mac on 16/10/18.
//  Copyright © 2018 Krishna_Mac_6. All rights reserved.
//

import Foundation
import Alamofire

class SwapPlayerService: NSObject {
    
    enum WebServiceNames: String {
        case baseUrl = "http://200.124.153.227/api/"
        case swapPlayer = "Upcoming/SwapPlayer/val"
    }
    
    // MARK: - Login Variables
    var swapPlayerDetailData : NSDictionary?
    
    func swapPlayer(longValue: Int64,intValue: Int64, playerId: Int64, completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.swapPlayer.rawValue
        let params = ["longValue":longValue,"intValue":intValue,"playerId":playerId] as [String : Any]
        SwapPlayerService.postWebService(urlString: url, params: params as [String : AnyObject]) { (response, message, status) in
            print(response ?? "Error")
            let result = SwapPlayerService()
            if let data = response as? NSDictionary {
                print(data)
                result.swapPlayerDetailData = data
                completion(result, "Success", true)
            }else {
                completion("" as AnyObject?, "Failed", false)
            }
        }
    }
    //MARK :- Post
    class func postWebService(urlString: String, params: [String : AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> Void) {
        alamofireFunction(urlString: urlString, method: .post, paramters: params) { (response, message, success) in
            if response != nil {
                completion(response as AnyObject?, "", true)
            }else{
                completion(nil, "", false)
            }
        }
    }
    
    class func alamofireFunction(urlString : String, method : Alamofire.HTTPMethod, paramters : [String : AnyObject], completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> Void){
        
        var theJSONText = ""
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: paramters,
            options: []) {
            theJSONText = String(data: theJSONData,
                                 encoding: .ascii)!
            print("JSON string = \(theJSONText)")
        }
        
        let path:URLConvertible = urlString
        
        let urlString = path
        let json = theJSONText
        print(json)
        
        let url = URL(string: urlString as! String)!
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
        print(jsonData)
        let userId: Int = UserDefaults.standard.integer(forKey: "UserId")
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(userId),forHTTPHeaderField: "Authorization")
        
        request.httpBody = jsonData
        
        
        if method == Alamofire.HTTPMethod.post {
            Alamofire.request(request).responseJSON { (response:DataResponse<Any>) in
                print(response.request ?? "nil")
                print(urlString)
                
                if response.result.isSuccess{
                    completion(response.result.value as AnyObject?, "", true)
                }else{
                    completion(nil, "", false)
                }
            }
            
        }else {
            Alamofire.request(urlString).responseJSON { (response) in
                
                if response.result.isSuccess{
                    completion(response.result.value as AnyObject?, "", true)
                }else{
                    completion(nil, "", false)
                }
            }
        }
    }
    
    //Mark:-Cancel
    class func cancelAllRequests()
    {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
}


//
//  UploadProfilePicService.swift
//  YourPic
//
//  Created by Krishna_Mac_6 on 13/04/18.
//  Copyright © 2018 Krishna_Mac_6. All rights reserved.
//

import Foundation
import Alamofire

class UploadProfilePicService: NSObject {
    
    enum WebServiceNames: String {
        case baseUrl = "http://200.124.153.227/api/"
        case uploadImage = "Account/UploadImage/"
    }
    
    func uploadImage(userId: String, imageData: Data?, onCompletion: ( @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ())){
        
        let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.uploadImage.rawValue + userId
        print(url)
        
        let headers: HTTPHeaders = [
            "Authorization": userId,
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            var params = [String:AnyObject]();
            params["userId"] = userId as AnyObject
            
            multipartFormData.append(imageData!, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            for (key, value) in params {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    //                        self.showSuccesAlert()
                    //self.removeImage("frame", fileExtension: "txt")
                    if let JSON = response.result.value
                    {
                        print("JSON: \(JSON)")
                        onCompletion(JSON as AnyObject, "Success", true)
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                onCompletion("" as AnyObject?, "Failed", false)
                print(encodingError)
            }
        }
    }
}
     

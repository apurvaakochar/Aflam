//
//  ServerRequest.swift
//  Aflam
//
//  Created by Apurva Kochar on 8/31/18.
//  Copyright © 2018 careem. All rights reserved.
//

import Foundation
import Alamofire

class ServerRequest {
    func getRequest(path: String, parameters: Dictionary<String,Any>, completionHandler: @escaping (Any) -> Void)
    {
        Alamofire.request(path, parameters: parameters).responseJSON{
            response in
            if let result = response.result.value{
                completionHandler(result)
            }
            
        }
    }
}

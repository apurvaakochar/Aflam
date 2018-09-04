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
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func getRequest(path: String, parameters: Dictionary<String,Any>, completionHandler: @escaping (Any?) -> Void) {
        Alamofire.request(path, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                if let result = response.result.value{
                    completionHandler(result)
                }
                else {
                    completionHandler(nil)
                }
            }
            else {
                completionHandler(nil)
            }
        }
    }
}

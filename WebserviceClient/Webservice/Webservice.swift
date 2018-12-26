//
//  Webservice.swift
//  VideoApp
//
//  Created by Vikash on 01/11/18.
//  Copyright © 2018 Vikash. All rights reserved.
//

import Foundation


enum Webservice {
    static let baseUrl = "your_base_url"
    
    // create webservice callilng function module wise.
    
    enum User {
        private static let sinupPath = Webservice.baseUrl + "register/normal/"
        private static let loginPath = Webservice.baseUrl + "Login/normal/"
        private static let facebookLogin = Webservice.baseUrl + "login/facebook/"
        private static let googleLogin = Webservice.baseUrl + "login/google/"
        
        static func sinup(parameter: Parameter, completion: @escaping APIResultBlock) {
            let request = APIRequest(path: sinupPath, method: .post, parameter: parameter, completion: completion)
            request.execute()
        }
        
        static func login(parameter: Parameter, completion: @escaping APIResultBlock) {
            let request = APIRequest(path: loginPath, method: .post, parameter: parameter, completion: completion)
            request.execute()
        }
        
        static func facebookLogin(parameter: Parameter, completion: @escaping APIResultBlock) {
            let request = APIRequest(path: facebookLogin, method: .post, parameter: parameter, completion: completion)
            request.execute()
        }

    }
    
    
    enum Post {
        static let createPostPath = Webservice.baseUrl + "post/create/"
        
        static func ceratePost(parameter: Parameter, completion: @escaping APIResultBlock) {
            
        }
        
    }
    
    
}

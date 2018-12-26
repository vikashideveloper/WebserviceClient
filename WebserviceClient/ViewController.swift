//
//  ViewController.swift
//  WebserviceClient
//
//  Created by Vikash on 26/12/18.
//  Copyright © 2018 Vikash Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // Below func tell you How to use webservice.
    
    func login() {
        let params = ["username": "yourusername", "password": "yourpassword"]
        
        Webservice.User.login(parameter: params) { result in
            switch result {
            case .fail(let errorMessage):
                print(errorMessage)
                
            case .success(let response):
                print(response.body)
                // parse response body that has actual response json from server.
            }
        }
    }
    
    
    
    func createPost() {
        let params = ["title": "titl", "otherinfo": "otherparameters"]

        Webservice.Post.ceratePost(parameter: params) { result in
            switch result {
            case .fail(let errorMessage):
                print(errorMessage)
                
            case .success(let response):
                print(response.body)
                // parse response body that has actual response json from server.
            }

        }
    }
    
    
}


//
//  APIClient.swift
//  GAG9APP
//
//  Created by Vikash on 27/11/18.
//  Copyright © 2018 Vikash Kumar. All rights reserved.
//

import Foundation
import Alamofire


typealias Parameter = [String : Any]
typealias APIResultBlock = (APIClientResult) -> Void

typealias ResponseBody = [String : Any]

private let ResponseParseErrorMessage = "Sorry! we couldn't parse the server response."

struct APIResponse {
    var statusCode: Int = -1
    var body: ResponseBody?
    var message: String = ""
    
    init() {
        //
    }
    
    init(_ json: ResponseBody) {
        // handle response code and message
        // it may be different as per API development.
        guard let code = json["ResultCode"] as? Int else { return }
        guard let msg = json["Message"] as? String else { return }

        statusCode = code
        body = (json["body"] as? ResponseBody) ?? json
        message = msg
    }
}

// Result : will be returned to API caller
enum APIClientResult {
    case fail(String)
    case success(APIResponse)
}

// not using in current version
enum APIClientUploadDownloadResult {
    case fail(Error)
    case success(Any)
    case progress(Float)
}

protocol EndPointProtocol {
    var path: String { get set }
    var method: HTTPMethod  { get set }
    var parameter: Parameter?  { get set }
    var resultCompletion: APIResultBlock?  { get set }
}

struct  APIRequest: EndPointProtocol {
    var path: String
    var method: HTTPMethod
    var parameter: Parameter?
    var resultCompletion: APIResultBlock?
    var authorizedToken: String?
    
    init(path: String, method: HTTPMethod = .get, parameter: Parameter? = nil, authToken: String? = nil, completion: @escaping APIResultBlock) {
        self.path = path
        self.method = method
        self.parameter = parameter
        self.authorizedToken = authToken
        self.resultCompletion = completion
    }
    
    func execute() {
        APIClient.shared.performTask(with: self)
    }
    
    func executeMultiPart() {
        APIClient.shared.performMultipartTask(with: self)
    }
}


class APIClient: NSObject {
    
    static let shared = APIClient()
    
    let session = Alamofire.SessionManager.default
    
    func performTask(with request: APIRequest) {
        
        let headers = APIClient.httpsHeaders(with: request.authorizedToken)
        
        session.request(request.path, method: request.method,
                        parameters: request.parameter, encoding: URLEncoding.default,
                        headers: headers)
            .responseJSON { (response) in
                switch response.result {
                    case .failure(let error):
                        request.resultCompletion?(.fail(error.localizedDescription))
                    
                case .success(let value):
                        if let json = value as? ResponseBody {
                            print(json)
                            let responseObj = APIResponse(json)
                            //
                            if responseObj.statusCode == 1 {
                                request.resultCompletion?(.success(responseObj))
                            } else {
                                request.resultCompletion?(.fail(responseObj.message))
                            }
                        } else {
                            request.resultCompletion?(.fail(ResponseParseErrorMessage))
                        }
                }
        }
    }
    
    
    func performDownloadTask(with request: APIRequest) {
        
    }
    
    func performUploadTask(with endpoint: APIRequest) {
        
    }
    
    func performMultipartTask(with endpoint: APIRequest) {
        
    }
    
    // class methods
    class func httpsHeaders(with token: String?) -> HTTPHeaders {
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        if let token = token {
            defaultHeaders["Authorization"] = "Bearer \(token)"
        }
        return defaultHeaders
    }

}

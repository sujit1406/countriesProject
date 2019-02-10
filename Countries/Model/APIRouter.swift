//
//  APIRouter.swift
//  Countries
//
//  Created by Sujith Antony on 05/02/19.
//  Copyright © 2019 Sujith Antony. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {

    case getCountries(keyWord:String)
    case getFlag(url:String)
    
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .getCountries, .getFlag:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .getCountries(let countryname):
            return "/rest/v2/name/\(countryname)"
        case .getFlag(let url):
            return url
    }
    }
        
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)        
        return urlRequest
    }

}

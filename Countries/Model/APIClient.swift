//
//  APIClient.swift
//  Countries
//
//  Created by Sujith Antony on 05/02/19.
//  Copyright © 2019 Sujith Antony. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIClient {
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T>)->Void) -> DataRequest {
        return Alamofire.request(route)
            .responseData{ response in
                let result : Result<T> = decoder.decodeResponse(from: response)
                    completion(result)}
    }
    
    static func getCountriesList(keyword:String,completion:@escaping (Result<[Country]>)->Void){
        performRequest(route: APIRouter.getCountries(keyWord: keyword), completion: completion)
    }
    
    static func getFlag(url:String,completion:@escaping (Data)->Void){
        Alamofire.request(url, method: .get, parameters: nil).response { response in
            if let data = response.data {
                completion(data)
            }
        }
    }
}


extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            print(response.error!)
            return .failure(response.error!)
        }
        
        guard let responseData = response.data else {
            print("didn't get any data from API")
            return .failure(response.error!)
        }
        
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("error trying to decode response")
            print(error)
            return .failure(error)
        }
    }
}


struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}

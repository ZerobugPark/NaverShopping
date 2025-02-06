//
//  NetworkMangerMVVM.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/6/25.
//

import Foundation

import Alamofire


enum NaverRequest {
    
    
    case getInfo(query: String, display: Int, sort: String, startIndex: Int)
    
    var baseURL: String {
        "https://openapi.naver.com/v1/search/shop.json"
    }
    

    
    var endPoint: URL {
        switch self {
        case.getInfo:
            return URL(string: baseURL)!
        }
        
        
    }
    
    var header: HTTPHeaders {
        return ["X-Naver-Client-Id": APIKey.clientId, "X-Naver-Client-Secret": APIKey.clientSecret]
        
    }

    
    var method: HTTPMethod {
        return .get
    }
    
    var parameter: Parameters? {
        switch self {
        case let .getInfo(query: query, display: display, sort: sort, startIndex: startIndex):
            let parameters = ["query": query, "display": String(display), "sort": sort, "start": String(startIndex)]
            return parameters
   
        }
        
    }
    
}

class NetworkManagerMVVM {
    
    static let shared = NetworkManagerMVVM()
    
    private init() { }
    

    func callRequest<T: Decodable> (api: NaverRequest, type: T.Type, completionHandler: @escaping (Result <(T), AFError>) -> Void) {
        
        
        if false {
            AF.request(api as! URLRequestConvertible).responseString { value in
                print(value)
            }
        }
        
        print(api)
        
        
        
        AF.request(api.endPoint, method: api.method, parameters: api.parameter, encoding: URLEncoding(destination: .queryString),headers: api.header).validate(statusCode: 0..<300).responseDecodable(of: T.self) { response in
            
            switch response.result {
            case .success(let value):
                completionHandler(.success(value))
            case.failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    

}

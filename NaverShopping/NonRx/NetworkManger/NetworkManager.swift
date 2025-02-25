//
//  NetworkManager.swift
//  NaverShopping
//
//  Created by youngkyun park on 1/17/25.
//

import UIKit
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    

    func loadData(searchItem: String, apiParm:  APIParameter ,completionHandler: @escaping (NaverShoppingInfo) -> Void) {
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(searchItem)&display=\(apiParm.display)" + "&sort=\(apiParm.sort)&start=\(apiParm.startIndex)"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.clientId, "X-Naver-Client-Secret": APIKey.clientSecret]
        
        if false {
            AF.request(url, method: .get, headers: header).responseString { value in
                print(value)
            }
        }
        AF.request(url, method: .get, headers: header).validate(statusCode: 0..<300).responseDecodable(of: NaverShoppingInfo.self) { response in
            
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}

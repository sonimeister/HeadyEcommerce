//
//  NetworkManager.swift
//  HeadyEcommerce
//
//  Created by Roshan Soni on 04/01/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import Foundation

class NetworkManager: NSObject {
    
    static let sharedInstance: NetworkManager = { return NetworkManager() }()
    
    func getDataFromServer(successBlock:@escaping(_ responseData:Any?) -> () ,failureBlock:@escaping(_ error: Error?) -> ()) {
        if let url = URL(string: SERVER_URL) {
            URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else { return failureBlock(error)  }
                
                do {
                    let decoder = JSONDecoder()
                    let jsonCategoryData = try decoder.decode(jsonBase.self, from: data)
                    successBlock(jsonCategoryData)
                    
                } catch let err {
                    failureBlock(err)
                }
                
            }).resume()
        }
    }
    
}

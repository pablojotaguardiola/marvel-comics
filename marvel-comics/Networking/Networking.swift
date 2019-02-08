//
//  Networking.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift
import CryptoSwift

public class Networking: NSObject {
    
    public enum Operation: String {
        case getComicList = "v1/public/comics"
        
        func url() -> String {
            let timestamp = Date().timeIntervalSince1970
            let hash = "\(timestamp)\(privateKey)\(apiKey)".md5()
            return "\(baseUrl)\(self.rawValue)?ts=\(timestamp)&hash=\(hash)&apikey=\(apiKey)"
        }
    }
    
    private static let apiKey: String = "8ac198f4f515003f4de6ec7ddb989dac"
    private static let privateKey: String = "f7d8b0f1c8537fd7ec8005667210ce6c1e249dd1"
    private static let baseUrl: String = "https://gateway.marvel.com:443/"
    
    private var request: DataRequest?
    
    public func get<T: Decodable>(type: T.Type, operation: Operation) -> SignalProducer<T, NetworkingError> {
        return SignalProducer { observer, _ in
            self.request?.cancel()
            
            self.request = Alamofire.request(operation.url()).responseData { response in
                guard
                    let data = response.value
                else {
                    observer.send(error: .parseError)
                    return
                }
                
                do {
                    let resp = try JSONDecoder().decode(T.self, from: data)
                
                    observer.send(value: resp)
                    observer.sendCompleted()
                }
                catch let e {
                    print(e)
                }
            }
        }
    }
    
    public func cancel() {
        request?.cancel()
    }
}

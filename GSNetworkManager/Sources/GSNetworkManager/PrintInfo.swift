//
//  PrintInfo.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation
import UIKit

class PrintInfo{
    // MARK: - Properties
    static let shared: PrintInfo = PrintInfo()
}

extension PrintInfo {
    
    internal func printRequest(request: URLRequest?) {
        guard let request = request else { return }
        print("\n--------------------- REQUEST --------------------- \n ")
        defer { print("--------------------- END --------------------- \n") }
        
        let urlAbsoluteString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAbsoluteString)
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var requestOutput = """
        \(urlAbsoluteString)
        \(method) \(path)?\(query) HTTP/1.1
        HOST: \(host)\n
        """
        let dictionary = request.allHTTPHeaderFields ?? [:]
        let sortedKeys = dictionary.keys.sorted()
        for key in sortedKeys {
            requestOutput += "\(key): \(dictionary[key] ?? "")\n"
        }
        if let body = request.httpBody {
            requestOutput += "\(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        print(requestOutput)
    }
    
    internal func printResponse(response: URLResponse?) {
        print("\n--------------------- RESPONSE --------------------- \n ")
        defer { print("--------------------- END --------------------- \n") }
        
        guard let urlResponse = response as? HTTPURLResponse else {
            print("Failed to get url response")
            return
        }
        let statusCode = urlResponse.statusCode
        let dictionary = urlResponse.allHeaderFields
        
        var responseOutput = """
        \(statusCode)\n
        """
        for key in dictionary.keys {
            responseOutput += "\(key): \(dictionary[key] ?? "")\n"
        }
        
        print(responseOutput)
    }
    
    internal func printData(data: Data) {
        print("\n--------------------- DATA --------------------- \n ")
        defer { print("--------------------- END --------------------- \n") }
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        print(json ?? "")
    }
}


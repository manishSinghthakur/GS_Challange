//
//  MultiPartParameterEncoder.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation

public struct MultiPartParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters, imageParameters: Parameters?) throws {
        var data = Data()
        let contentType = urlRequest.allHTTPHeaderFields!["Content-Type"]
        let boundaryParameter = contentType!.split{$0 == " "}.map(String.init)
        let boundaryElement = boundaryParameter.last!.split{$0 == "="}.map(String.init)
        guard let boundary = boundaryElement.last else { return}
        for (key, value) in parameters {
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(value)".data(using: .utf8)!)
        }

        if let multipartParameter = imageParameters, let imageData = multipartParameter["imageData"] as? Data {
            // Add the image to the raw http request data
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(String(describing: multipartParameter["imageName"]))\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(imageData)
        }
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        urlRequest.httpBody = data
    }
}


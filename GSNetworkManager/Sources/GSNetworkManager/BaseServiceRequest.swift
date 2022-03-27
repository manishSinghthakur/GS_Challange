//
//  BaseServiceRequest.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation
import UIKit

open class BaseServiceRequest<T: Decodable>: RequestEndPoint {
    
    public typealias Response = T
    
    public init(){}
    
    open var environment: NetworkEnvironment {
        return  NetworkEnvironment.development
    }
    
    open var baseCloudURL: String {
        switch environment {
        case .development : return "https://api.nasa.gov/planetary/"
        case .qa : return "https://api.nasa.gov/planetary/"
        case .staging : return "https://api.nasa.gov/planetary/"
        case .production : return "https://api.nasa.gov/planetary/"
        }
    }
    
    open var baseURL: URL {
        guard let url = URL(string: baseCloudURL) else
        {fatalError("baseURL could not be configured.")}
        return url
    }
    
    open var path: String {
        return ""
    }
    
    open var headers: NetworkHeaderInfo? {
        return NetworkHeaderInfo(with: environment, parameters: nil)
    }
    
    open var httpMethod: HTTPMethod {
        return .get
    }
    
    open var task: HTTPTask {
        return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil, additionHeaders: true)
    }
    
    open func decode(_ data: Data) throws -> Response {
        guard let responseModel = try? JSONDecoder().decode(BaseServiceResponseModel.self, from: data) else {
            return BaseServiceResponseModel(data: "") as! BaseServiceRequest<T>.Response
        }
        return responseModel as! BaseServiceRequest<T>.Response
    }
}

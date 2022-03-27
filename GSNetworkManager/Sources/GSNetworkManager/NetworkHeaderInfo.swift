//
//  NetworkHeaderInfo.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation

//  MARK: - Alias
public typealias HTTPHeaders = [String:String]
public typealias HeaderParameters = [String:String]


//  MARK: - Base Class
open class NetworkHeaderInfo: NSObject {
    
    //  MARK: - Properties
    fileprivate let kDeviceType: String  = "X-Device-Type"
    fileprivate let kPlatform: String    = "X-Platform"
    fileprivate let kEnvironment: String = "X-Environment"
    fileprivate let kLanguage: String    = "Content-Language"
    fileprivate let kContentType: String = "Content-Type"
    fileprivate var data: NetworkHeaderData
    public var headers: HTTPHeaders
    
    //  MARK: - Life Cycle
    fileprivate override init() {
        //  abstract class, so no values
        self.data = NetworkHeaderDataDev()
        self.headers = [:]
        super.init()
    }
    
    fileprivate func initHeaders(_ parameters: HeaderParameters?) {
        self.headers = [
            self.kDeviceType  : self.data.deviceType,
            self.kPlatform    : self.data.platform,
            self.kEnvironment : self.data.environment.prefix,
            self.kLanguage    : self.data.language,
            self.kContentType : self.data.contentType
        ]
        guard let headerParameters = parameters else { return }
        self.headers.merge(headerParameters)
    }
    
    public convenience init(with environment: NetworkEnvironment, parameters: HeaderParameters?) {
        self.init()
        switch environment {
        case .development:  self.data = NetworkHeaderDataDev()
        case .qa:           self.data = NetworkHeaderDataQa()
        case .staging:      self.data = NetworkHeaderDataStaging()
        case .production:   self.data = NetworkHeaderDataProd()
        }
        self.initHeaders(parameters)
    }
}



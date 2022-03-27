//
//  NetworkEnums.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation

/// enum type that defines the network request type
@frozen
public enum HTTPMethod : String, CaseIterable, Codable {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

/// enum type that reflects on actual http response status code
/// has properties of code, domain and nserror objects that are localized
/// and categorized
@frozen
public enum HTTPResult: Int, Error, LocalizedError, CaseIterable, Codable {
    case success                        = 200
    case failedClientRequest            = 400
    case failedClientRequestParameters  = 422
    case failedClientUnauthorized       = 401
    case failedClientForbidden          = 403
    case failedClientNotFound           = 404
    case failedClientAuthentication     = 407
    case failedClientTimeout            = 408
    case failedClientMisc               = 499
    case failedServerInternal           = 500
    case failedServerUnavailable        = 503
    case failedServerTimeout            = 504
    case failedServerAuthentication     = 511
    case failedServerMisc               = 599
    case failedUndefined                = 999
    
    public var code:Int {
        return self.rawValue
    }
    
    public var domain: String {
        var description:String = ""
        if (self.code == 200) {
            description = "networkDomain.success".localized
        }
        if (self.code >= 400 && self.code <= 499) {
            description = "networkDomain.client".localized
        }
        if (self.code >= 500 && self.code <= 599) {
            description = "networkDomain.server".localized
        }
        if (self.code == 999) {
            description = "networkDomain.undefined".localized
        }
        return description
    }
    
    public var error: Error? {
        var dict:[String:Any] = [:]
        if (code == 200) {
            dict["message"] = "networkError.success".localized
        }
        if (code >= 400 && code <= 499) {
            dict["message"] = "networkError.client".localized(with: [code])
        }
        if (code >= 500 && code <= 599) {
            dict["message"] = "networkError.server".localized(with: [code])
        }
        if (self.code == 999) {
            dict["message"] = "networkError.undefined".localized(with: [code])
        }
        if (self == .success) { return nil }
        else {
            return NSError(domain: domain, code: code, userInfo: dict)
        }
    }
    
    public var errorDescription: String? {
        return "\(self)"
    }
    
}

/// enum type that defines different types network environment
@frozen
public enum NetworkEnvironment: String, CaseIterable, Codable {
    case development
    case qa
    case staging
    case production
    
    public var prefix:String {
        var prefixKey:String = ""
        switch self {
        case .development:  prefixKey = "dev"
        case .qa:           prefixKey = "qa"
        case .staging:      prefixKey = "staging"
        case .production:   prefixKey = "prod"
        }
        return prefixKey
    }
}

/// enum type that defines different types network  errors
@frozen
public enum NetworkError : Error {
    case parametersNil
    case encodingFailed
    case missingURL
    
    func networkError(_ type: NetworkError) -> String? {
        switch self {
        case .parametersNil: return "networkError.parametersNil".localized
        case .encodingFailed: return "networkError.encodingFailed".localized
        case .missingURL: return "networkError.missingURL".localized
        }
    }
}


/// Enum for notification names
enum NotificationNames: String {
    case flagsChanged = "flagsChanged_Notification"
}

// MARK: - Notification+Name extension for Custom Notification names.
extension Notification.Name {
    
    /// Network change update Notification.
    public static let FlagsChanged = Notification.Name(NotificationNames.flagsChanged.rawValue)
    
}

/// enum type for selected days to fetch Network Log
@frozen
public enum RecordRange: Int,CaseIterable, Codable {
    case all                            = 0
    case week                           = 7
    case threeDays                      = 3
    case month                          = 30
    
    public var code:Int {
        return self.rawValue
    }
}

//
//  NetworkHeaderData.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation

#if os(iOS) || os(watchOS)
import UIKit
#endif

//  MARK: - Base Class
public class NetworkHeaderData: NSObject {
    
    //  MARK: - Properties
    var deviceType:String
    var platform:String
    var language:String
    var environment: NetworkEnvironment
    var contentType:String
    
    fileprivate override init() {
        //  abstract class, so no values
        self.deviceType = ""
        self.platform   = ""
        self.language   = ""
        self.environment = .development
        self.contentType  = ""
    }

    fileprivate func initDefaults() {
        #if os(iOS) || os(watchOS) || targetEnvironment(simulator)
            self.deviceType  = UIDevice.current.model
            self.platform    = UIDevice.current.systemName
        #endif
        self.language    = Locale.current.languageCode ?? "en"
        self.environment = .development
        self.contentType = "application/json"
    }
}

//  MARK: - Header Data Development
class NetworkHeaderDataDev: NetworkHeaderData {
    override init() {
        super.init()
        self.initDefaults()
        //  Override, if required
        self.environment = .development
    }
}
//h •gt5ygu7
//  MARK: - Header Data QA
class NetworkHeaderDataQa: NetworkHeaderData {
    override init() {
        super.init()
        self.initDefaults()
        //  Override, if required
        self.environment = .qa
    }
}

//  MARK: - Header Data Staging
class NetworkHeaderDataStaging: NetworkHeaderData {
    override init() {
        super.init()
        self.initDefaults()
        //  Override, if required
        self.environment = .staging
    }
}

//  MARK: - Header Data Production
class NetworkHeaderDataProd: NetworkHeaderData {
    override init() {
        super.init()
        self.initDefaults()
        //  Override, if required
        self.environment = .production
    }
}

//
//  UserDefaultsManager.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation

//  MARK: - Base Class
open class UserDefaultsManager: NSObject {
    // MARK: - Properties
    public static let shared: UserDefaultsManager = UserDefaultsManager()
    
    //  MARK: - Properties
    public let defaults = UserDefaults.standard
    
}

extension UserDefaultsManager {
    
    //  MARK: - Setter Methods
    public func setIntValue(forKey: String, value: Int) {
        defaults.set(value, forKey: forKey)
    }
    
    public func setStringValue(forKey: String, value: String) {
        defaults.set(value, forKey: forKey)
    }
    
    public func setBoolValue(forKey: String, value: Bool) {
        defaults.set(value, forKey: forKey)
    }
    
    public func setData(forKey: String, value: Any) {
        defaults.set(value, forKey: forKey)
    }
    
    //  MARK: - Getter Methods
    public func getIntValue(forKey: String) -> Int {
        return defaults.integer(forKey: forKey)
    }
    
    public func getStringValue(forKey: String) -> String {
        guard let value = defaults.string(forKey: forKey) else {
            return ""
        }
        return value
    }
    
    public func getBoolValue(forKey: String) -> Bool {
        return defaults.bool(forKey: forKey)
    }
    
    public func getData(forKey: String) -> Data? {
        var value: Data? = nil
        guard let data = defaults.data(forKey: forKey) else {
            return value
        }
        value = data
        return value
    }
}

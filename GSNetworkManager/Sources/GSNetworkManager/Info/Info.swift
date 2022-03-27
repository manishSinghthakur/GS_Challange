//
//  File.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation

//  MARK: - Base Class
open class NetworkInfo{
    // MARK: - Properties
    public static let shared: NetworkInfo = NetworkInfo()
    public var version: String {
        let dictionary = Bundle(for: Self.self).infoDictionary!
        let version = String(describing: dictionary["CFBundleShortVersionString"] ?? "")
        let build = String(describing: dictionary["CFBundleVersion"] ?? "")
        return "Package \(version) (\(build))"
    }
}

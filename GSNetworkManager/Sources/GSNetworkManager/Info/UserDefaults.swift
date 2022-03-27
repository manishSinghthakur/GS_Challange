//
//  File.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation

extension UserDefaults {
    
    public func set<Element: Codable>(value: Element, forKey key: String) {
        let data = try? JSONEncoder().encode(value)
        UserDefaults.standard.setValue(data, forKey: key)
    }
    
    public func codable<Element: Codable>(forKey key: String) -> Element? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        let element = try? JSONDecoder().decode(Element.self, from: data)
        return element
    }
}

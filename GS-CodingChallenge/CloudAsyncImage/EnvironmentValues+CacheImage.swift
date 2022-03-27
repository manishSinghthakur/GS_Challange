//
//  EnvironmentValues+CacheImage.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: CacheImage = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: CacheImage {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

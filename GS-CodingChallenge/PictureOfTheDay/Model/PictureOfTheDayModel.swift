//
//  PictureOfTheDayModel.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation

// MARK: - PictureOfTheDayModel

struct PictureOfTheDayModel: Codable, Identifiable {
    let copyright, date, explanation: String?
    let hdurl: String?
    let mediaType, serviceVersion, title: String?
    let url: String?
    var id: String {url ?? ""}

    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}

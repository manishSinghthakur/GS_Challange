//
//  PictureOfTheDayRequest.swift
//  GS-CodingChallenge
//
//  Created by Manish on 26/03/22.
//

import Foundation
import GSNetworkManager

enum PictureOption: Int {
    case pictureOfTheDay = 0
    case pictureForSelectedDay = 1
}

class PictureOfTheDayRequest<T: Decodable>: BaseServiceRequest<T> {
    
    typealias Response = T
    var searchBy: PictureOption?
    var selectedDate: String = ""

    init(_ searchBy: PictureOption?, selectedDate: String){
        self.searchBy = searchBy
        self.selectedDate = selectedDate
    }
    
    override var path: String {
        switch(searchBy){
        case .pictureOfTheDay :
            return "apod?api_key=VwjoaBDNAIxliae25GtOOy0IbSKeP5dtPHpkagTH"
        case .pictureForSelectedDay:
            return "apod?api_key=VwjoaBDNAIxliae25GtOOy0IbSKeP5dtPHpkagTH&date=\(self.selectedDate)"
        case .none:
            break
        }
        return ""
    }
    
    override var httpMethod: HTTPMethod {
        return .get
    }
    
    override var task: HTTPTask {
        return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: true)
    }
    
    override func decode(_ data: Data) throws -> Response {
        guard let responseModel = try? JSONDecoder().decode(PictureOfTheDayModel.self, from: data) else {
            return PictureOfTheDayModel(copyright: "", date: "", explanation: "", hdurl: "", mediaType: "", serviceVersion: "", title: "", url: "") as! PictureOfTheDayRequest<T>.Response
        }
        return responseModel as! PictureOfTheDayRequest<T>.Response
    }
}

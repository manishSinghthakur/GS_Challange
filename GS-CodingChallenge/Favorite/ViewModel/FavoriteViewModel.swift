//
//  FavoriteViewModel.swift
//  GS-CodingChallenge
//
//  Created by Manish on 27/03/22.
//

import Foundation
import GSNetworkManager

class FavoriteViewModel: ObservableObject {
    
    @Published var favoriteModelList: [FavoriteModel] = []
    
    func fetchFavoriteRecord() {
        var favoriteList: [FavoriteModel] = []
        let records = NetworkManager.shared.fetchFavoriteRecord()
        for record in records {
            favoriteList.append(FavoriteModel(copyright: record.copyright, date: record.date, explanation: record.explanation, hdurl: record.hdurl, mediaType: record.mediaType, serviceVersion: record.serviceVersion, title: record.title, url: record.url))
        }
        self.favoriteModelList = favoriteList
    }
}

//
//  PictureOfTheDayViewModel.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation
import GSNetworkManager

class PictureOfTheDayViewModel: ObservableObject {
    
    @Published var pictureDetailList: [PictureOfTheDayModel] = []
    
    func string(_date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: _date)
    }
    
    func getPictureOfTheDay() {
        if NetworkReachabilityManager.reachability?.isConnectedToNetwork  == true {
            let restRequest = PictureOfTheDayRequest<PictureOfTheDayModel>(.pictureOfTheDay, selectedDate: "")
            NetworkManager.shared.request(restRequest, screenName: "Home", action: "Picture Of The Day") { [weak self] result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self?.pictureDetailList.removeAll()
                        self?.pictureDetailList.append(response)
                        self?.saveLastPictureRecord(record: response)
                    }
                case .failure(let error):
                    print(error.errorDescription ?? "")
                }
            }
        }else{
            self.pictureDetailList.removeAll()
            self.pictureDetailList.append(self.fetchLastRecord())
        }
    }
    
    func getPictureOfTheDayForSelectedDate(_ selectedDate: String) {
        if NetworkReachabilityManager.reachability?.isConnectedToNetwork == true {
            
            let restRequest = PictureOfTheDayRequest<PictureOfTheDayModel>(.pictureForSelectedDay, selectedDate: selectedDate)
            NetworkManager.shared.request(restRequest, screenName: "Home", action: "Picture Of The Day For Selected Date") { [weak self] result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self?.pictureDetailList.removeAll()
                        self?.pictureDetailList.append(response)
                        self?.saveLastPictureRecord(record: response)
                    }
                case .failure(let error):
                    print(error.errorDescription ?? "")
                }
            }
        }
        else{
            self.pictureDetailList.removeAll()
            self.pictureDetailList.append(self.fetchLastRecord())
        }
    }
    
    func saveLastPictureRecord(record: PictureOfTheDayModel){
        NetworkManager.shared.saveLastRecord(title: record.title ?? "" , url: record.url ?? "", explanation: record.explanation ?? "", date: record.date ?? "", copyright: record.copyright ?? "", hdurl: record.hdurl ?? "", mediaType: record.mediaType ?? "", serviceVersion: record.serviceVersion ?? "")
    }
    
    func saveFavoriteRecord(record: PictureOfTheDayModel){
        NetworkManager.shared.saveFavoriteRecord(title: record.title ?? "" , url: record.url ?? "", explanation: record.explanation ?? "", date: record.date ?? "", copyright: record.copyright ?? "", hdurl: record.hdurl ?? "", mediaType: record.mediaType ?? "", serviceVersion: record.serviceVersion ?? "")
    }
    
    func fetchLastRecord() -> PictureOfTheDayModel {
        let record = NetworkManager.shared.fetchLastRecord()
        return PictureOfTheDayModel(copyright: record?.copyright, date: record?.date, explanation: record?.explanation, hdurl: record?.hdurl, mediaType: record?.mediaType, serviceVersion: record?.serviceVersion, title: record?.title, url: record?.url)
    }
}




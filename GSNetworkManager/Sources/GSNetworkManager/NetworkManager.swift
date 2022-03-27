//
//  NetworkManager.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import Foundation

//  MARK: - Base Class
open class NetworkManager{
    // MARK: - Properties
    public static let shared: NetworkManager = NetworkManager()
    private init() {
        checkNetworkConnectivity()
    }
}

// MARK: Class extension for Network API Request
extension NetworkManager {
    public func request<Request: RequestEndPoint>(_ request: Request, screenName: String,action: String?, completion: @escaping (Result<Request.Response, HTTPResult>) -> Void) {
        NetworkRequest.shared.send(request) { [weak self] data, response, error  in
            if let response = response as? HTTPURLResponse, let result = HTTPResult(rawValue: response.statusCode) {
                switch result {
                case .success:
                    guard let responseData = data else{return}
                    do {
                        PrintInfo.shared.printData(data: responseData)
                        self?.saveNetworkLogs(screenName, action: action,
                                              result: "Sucess", notes: "Status Code: \(response.debugDescription)")
                        try completion(.success(request.decode(responseData)))
                    } catch {
                        self?.saveNetworkLogs(screenName, action: action,
                                              result: "Failure", notes: "\(result.errorDescription!)\(result.code)")
                        completion(.failure(result))
                    }
                default :
                    return completion(.failure(result))
                }
            }
        }
    }
}

// MARK: Class extension for Network Reachability Check
extension NetworkManager {
    //Observe Network Connectivity
    func checkNetworkConnectivity() {
        do {
            NetworkReachabilityManager.reachability = try Reachability()
            do {
                try NetworkReachabilityManager.reachability?.start()
            } catch let error as NetworkReachabilityManager.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}

extension NetworkManager {
    internal func saveNetworkLogs(_ screenName: String, action: String?, result: String, notes: String) {
        NetworkCoreDataManager.shared.maintaneNetworkLog(screenName,
                                                         action: action, result: result, notes: notes)
    }
    
    public func saveLastRecord(title: String, url: String, explanation: String, date: String, copyright: String, hdurl: String, mediaType: String, serviceVersion: String){
        NetworkCoreDataManager.shared.maintaneLastRecord(title: title, url: url, explanation: explanation, date: date, copyright: copyright, hdurl: hdurl, mediaType: mediaType, serviceVersion: serviceVersion)
    }
    
    public func saveFavoriteRecord(title: String, url: String, explanation: String, date: String, copyright: String, hdurl: String, mediaType: String, serviceVersion: String){
        NetworkCoreDataManager.shared.maintaneFavoriteRecord(title: title, url: url, explanation: explanation, date: date, copyright: copyright, hdurl: hdurl, mediaType: mediaType, serviceVersion: serviceVersion)
    }
    
    public func fetchLastRecord() -> PictureLastRecord? {
        return NetworkCoreDataManager.shared.fetchLastupdatedRecord()
    }
    
    public func fetchFavoriteRecord() -> [Favorite] {
        return NetworkCoreDataManager.shared.fetchFavoriteRecord()
    }
}

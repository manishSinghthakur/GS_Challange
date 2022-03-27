//
//  NetworkCoreDataManager.swift
//  GS-CodingChallenge
//
//  Created by Manish on 25/03/22.
//

import CoreData

// A NSPersistentContainer property to perform coredata action
internal var persistentContainer: NSPersistentContainer? = {
    guard let modelURL = Bundle.module.url(forResource:"NisumNetwork", withExtension: "momd") else { return  nil }
    guard let model = NSManagedObjectModel(contentsOf: modelURL) else { return nil }
    let container = NSPersistentContainer(name:"NisumNetwork",managedObjectModel:model)
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()

public class NetworkCoreDataManager: ObservableObject {
    // A singleton for our entire app to use
    public static let shared = NetworkCoreDataManager()
}


extension NetworkCoreDataManager {
    
    internal func maintaneNetworkLog(_ screenName: String, action: String?,
                                     result: String, notes: String) {
        guard let container = persistentContainer else { return }
        let networkLog = NetworkLog(context: container.viewContext)
        networkLog.screenname = screenName
        networkLog.result = result
        networkLog.action = (action != nil) ? action : ""
        networkLog.notes = notes
        networkLog.time = Date()
        do {
            try container.viewContext.save()
            print("Log saved succesfuly")
        } catch let error {
            print("Failed to store log: \(error.localizedDescription)")
        }
    }
    
    public func maintaneLastRecord(title: String, url: String, explanation: String, date: String, copyright: String, hdurl: String, mediaType: String, serviceVersion: String) {
        clearCoreDataStore()
        guard let container = persistentContainer else { return }
        let pictureDetail = PictureLastRecord(context: container.viewContext)
        pictureDetail.copyright = copyright
        pictureDetail.date = date
        pictureDetail.hdurl = hdurl
        pictureDetail.url = url
        pictureDetail.explanation = explanation
        pictureDetail.title = title
        pictureDetail.mediaType = mediaType
        pictureDetail.serviceVersion = serviceVersion
        do {
            try container.viewContext.save()
            print("Log saved succesfuly")
        } catch let error {
            print("Failed to store log: \(error.localizedDescription)")
        }
    }
    
    public func maintaneFavoriteRecord(title: String, url: String, explanation: String, date: String, copyright: String, hdurl: String, mediaType: String, serviceVersion: String) {
        guard let container = persistentContainer else { return }
        
        let pictureDetail = Favorite(context: container.viewContext)
        pictureDetail.copyright = copyright
        pictureDetail.date = date
        pictureDetail.hdurl = hdurl
        pictureDetail.url = url
        pictureDetail.explanation = explanation
        pictureDetail.title = title
        pictureDetail.mediaType = mediaType
        pictureDetail.serviceVersion = serviceVersion
        do {
            try container.viewContext.save()
            print("Log saved succesfuly")
        } catch let error {
            print("Failed to store log: \(error.localizedDescription)")
        }
    }
    
    private func clearCoreDataStore() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PictureLastRecord")
        let deleteReqest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer?.viewContext.execute(deleteReqest)
        } catch {
            print(error)
        }
    }
    
    public func fetchFavoriteRecord() -> [Favorite] {
        let fetchRequest = NSFetchRequest<Favorite>(entityName: "Favorite")
        do {
            let fetchedResults = try persistentContainer?.viewContext.fetch(fetchRequest)
            guard let pictureResult = fetchedResults else {
                return []
            }
            let pictureObject: [Favorite] = pictureResult
            return pictureObject
        } catch let error as NSError {
            print(error.description)
        }
        return []
    }
    
    public func fetchLastupdatedRecord() -> PictureLastRecord? {
        let fetchRequest = NSFetchRequest<PictureLastRecord>(entityName: "PictureLastRecord")
        do {
            let fetchedResults = try persistentContainer?.viewContext.fetch(fetchRequest)
            guard let pictureResult = fetchedResults else {
                return nil
            }
            let pictureObject: PictureLastRecord = pictureResult[0]
            return pictureObject
        } catch let error as NSError {
            print(error.description)
        }
        return nil
    }
    
    public func fetchNetworkLog(_ daysRecord: RecordRange,
                                completion: @escaping ([NetworkLog]) -> Void) {
        var networkLogs = [NetworkLog]()
        guard let beginDate = Calendar.current.date(byAdding: .day, value: -(daysRecord.code), to: Date()), let container = persistentContainer else {return}
        let fetchRequest: NSFetchRequest<NetworkLog> = NetworkLog.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "time <= %@", beginDate as CVarArg)
        do {
            networkLogs = try container.viewContext.fetch(fetchRequest)
            completion(networkLogs)
        } catch let errore {
            print("error FetchRequest \(errore)")
        }
        completion(networkLogs)
    }
    
    public func viewNetworkLogs(_ daysRecord: RecordRange) -> NetworkLogView {
        return NetworkLogView(numberOfDaysRecord: daysRecord)
    }
}


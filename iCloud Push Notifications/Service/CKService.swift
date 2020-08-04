//
//  CKService.swift
//  iCloud Push Notifications
//
//  Created by Anya on 02.08.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import CloudKit

class CKService {
    
    private init() {}
    static var shared = CKService()
    
    let privateDataBase = CKContainer.default().privateCloudDatabase
    
    func save(record: CKRecord) {
        privateDataBase.save(record) { (record, error) in
            print(error ?? "No error when saving to CK")
            print(record ?? "No record saved to CK")
        }
    }
    
    func query(recordType: String, completion: @escaping ([CKRecord]) -> Void) {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        privateDataBase.perform(query, inZoneWith: nil) { (records, error) in
            print(error ?? "No CK query error")
            if let records = records {
                DispatchQueue.main.async {
                    completion(records)
                }
            }
            
        }
    }
    
    func subscribe() {
        let subscription = CKQuerySubscription(recordType: "Note", predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        
        subscription.notificationInfo = notificationInfo
        privateDataBase.save(subscription) { (subscription, error) in
            print(error ?? "No error subscribing to CK")
            print(subscription ?? "Can't subscribe to CK")
        }
    }
    
    func subscribeWithUI() {
        let subscription = CKQuerySubscription(recordType: "Note", predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "Hi there!"
        notificationInfo.subtitle = "You've got a new note"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        notificationInfo.alertLocalizationKey = "%1$@"
        notificationInfo.alertLocalizationArgs = ["title"]
        
        subscription.notificationInfo = notificationInfo
        privateDataBase.save(subscription) { (subscription, error) in
            print(error ?? "No error subscribing to CK")
            print(subscription ?? "Can't subscribe to CK")
        }
    }
    
    func fetchRecord(with recordID: CKRecord.ID) {
        privateDataBase.fetch(withRecordID: recordID) { (record, error) in
            print(error ?? "No CK record error")
            
            guard let record = record else {return}
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("internalNotification.fetchRecord"), object: record)
            }
        }
    }
    
    func handleNotification(with userInfo: [AnyHashable : Any]) {
        guard let notification = CKNotification(fromRemoteNotificationDictionary: userInfo) else {return}
        switch notification.notificationType {
        case .query:
            guard let queryNotification = notification as? CKQueryNotification,
                let recordId = queryNotification.recordID
                else {return}
            fetchRecord(with: recordId)
        default: return
        }
    }
}

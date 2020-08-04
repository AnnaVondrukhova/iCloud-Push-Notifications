//
//  Note.swift
//  iCloud Push Notifications
//
//  Created by Anya on 02.08.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import CloudKit

struct Note {
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    init?(record: CKRecord) {
        guard let title = record.value(forKey: "title") as? String else { return nil }
        
        self.title = title
    }
    
    func noteRecord() -> CKRecord {
        let record = CKRecord(recordType: "Note")
        record.setValue(self.title, forKey: "title")
        return record
    }
}

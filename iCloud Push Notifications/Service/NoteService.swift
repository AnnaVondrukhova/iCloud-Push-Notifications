//
//  NoteService.swift
//  iCloud Push Notifications
//
//  Created by Anya on 02.08.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import CloudKit

class NoteService {
    static func getNotesFromRecords(completion: @escaping ([Note]) -> Void) {
        CKService.shared.query(recordType: "Note") { (records) in
                    var notes = [Note]()
            for record in records {
                guard let note = Note(record: record) else {continue}
                notes.append(note)
            }
            
            completion(notes)
        }
    }
}

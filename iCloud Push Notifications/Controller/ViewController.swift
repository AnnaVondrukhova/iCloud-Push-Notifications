//
//  ViewController.swift
//  iCloud Push Notifications
//
//  Created by Anya on 02.08.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNotes()
        NotificationCenter.default.addObserver(self, selector: #selector(getNewNote(_:)), name: NSNotification.Name("internalNotification.fetchRecord"), object: nil)
        
    }

    @IBAction func composeBtnTapped(_ sender: Any) {
        AlertService.composeAlert(in: self) { (note) in
            CKService.shared.save(record: note.noteRecord())
            self.insertRow(with: note)
        }
    }
    
    func getNotes() {
        NoteService.getNotesFromRecords { (notes) in
            self.notes = notes
            self.tableView.reloadData()
        }
    }
    
    func insertRow (with note: Note) {
        self.notes.insert(note, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func getNewNote(_ sender: Notification) {
        guard let record = sender.object as? CKRecord,
            let note = Note(record: record)
        else {return}
        
        insertRow(with: note)
    }
    
}

extension ViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        return cell
    }
}

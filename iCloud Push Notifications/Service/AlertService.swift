//
//  AlertService.swift
//  iCloud Push Notifications
//
//  Created by Anya on 02.08.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import UIKit

class AlertService {
    static func composeAlert( in vc: UIViewController, completion: @escaping (Note) -> Void) {
        let alertController = UIAlertController(title: "New note", message: "What do you want to add?", preferredStyle: .alert)
        
        alertController.addTextField { (tf) in
            tf.placeholder = "New note"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            let title = alertController.textFields?.first?.text
            let note = Note(title: title!)
            completion(note)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
}

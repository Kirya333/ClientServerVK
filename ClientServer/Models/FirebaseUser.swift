//
//  FirebaseUser.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 25.07.2021.
//

import Foundation
import Firebase

class FirebaseUser {
    
    let id: String
    let ref: DatabaseReference?
    
    init(id: String) {
        self.id = id
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? String
        
        else { return nil }
        
        self.ref = snapshot.ref
        self.id = id
    }
    
    func toAnyObject() -> [String:Any] {
        return [
            "id": id
        ]
    }
}

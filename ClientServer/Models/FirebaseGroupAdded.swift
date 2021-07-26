//
//  FirebaseGroupAdded.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 25.07.2021.
//

import Foundation
import Firebase

class FirebaseGroupAdded {
    let id: Int
    let name: String
    let avatar: String
    let ref: DatabaseReference?
    
    init(id: Int, name: String, avatar: String) {
        self.ref = nil
        self.id = id
        self.name = name
        self.avatar = avatar
    }


    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? Int,
            let name = value["name"] as? String,
            let avatar = value["avatar"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.id = id
        self.name = name
        self.avatar = avatar
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "avatar": avatar
        ]
    }
}

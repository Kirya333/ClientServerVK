//
//  Friends.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 29.06.2021.
//

import Foundation
import RealmSwift


struct Friends: Codable {
    let response: ResponseFriends
}

struct ResponseFriends: Codable {
    let count: Int
    let items: [Friend]
}

class Friend: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var lastName: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var avatar: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case lastName = "last_name"
        case firstName = "first_name"
        case avatar = "photo_50"
    }
    
    func getFullName() -> String {
        return "\(firstName) \(lastName)"
    }
}

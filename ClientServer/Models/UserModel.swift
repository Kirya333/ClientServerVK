//
//  UserModel.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 04.07.2021.
//

import Foundation
import DynamicJSON
import RealmSwift

class UserModel: Object {

    @objc dynamic var id = 0
    @objc dynamic var lastName = ""
    @objc dynamic var firstName = ""
    @objc dynamic var avatar = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }

    convenience required init(data: JSON) {
        self.init()

        self.id = data.id.int ?? 0
        self.lastName = data.last_name.string ?? ""
        self.firstName = data.first_name.string ?? ""
        self.avatar = data.photo_50.string ?? ""
    }
    
    func getFullName() -> String {
        return "\(firstName) \(lastName)"
    }
}



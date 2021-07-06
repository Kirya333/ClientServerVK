//
//  UserModel.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 04.07.2021.
//

import Foundation
import DynamicJSON


class UserModel: BaseObject {

    var id: Int?
    var lastName: String?
    var firstName: String?
    var photo50: String?

    convenience required init(data: JSON) {
        self.init()

        self.id = data.id.int
        self.lastName = data.last_name.string
        self.firstName = data.first_name.string
        self.photo50 = data.photo_50.string
    }
    
    func getFullName() -> String {
        return "\(String(describing: firstName)) \(String(describing: lastName))"
    }
}



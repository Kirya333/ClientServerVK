//
//  User.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 10.09.2021.
//

import Foundation

struct User {
    let id: Int
    let lastName: String
    let firstName: String
    let avatar: String
    
    func getFullName() -> String {
        return "\(firstName) \(lastName)"
    }
}

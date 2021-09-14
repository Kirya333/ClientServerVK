//
//  Group.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 10.09.2021.
//

import Foundation

struct Group {
    let id: Int
    let name: String
    let avatar: String
}

extension Group: Equatable {
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name
    }
}

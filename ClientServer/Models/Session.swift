//
//  Session.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 29.06.2021.
//

import Foundation

final class Session {
    static let shared = Session()
    
    private init() {}
    
    var token: String = ""
    var userId: String = ""
}


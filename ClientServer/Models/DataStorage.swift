//
//  DataStorage.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 29.06.2021.
//

import Foundation


final class DataStorage {
    static let shared = DataStorage()
    
    private init() {}
    
    var newsArray = [FirebaseNews]()
}


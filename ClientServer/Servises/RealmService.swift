//
//  RealmService.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 26.07.2021.
//

import Foundation
import RealmSwift

protocol RealmServiceProtocol {
    func add(models: [Object])
    func read(object: Object.Type) -> [Object]
    func read(object: Object.Type, filter: String) -> [Object]
    func delete(model: Object)
}

class RealmService: RealmServiceProtocol {

    let config = Realm.Configuration(schemaVersion: 1)
    lazy var realm = try! Realm(configuration: config)

    func add(models: [Object]) {
        do {
            self.realm.beginWrite()
            self.realm.add(models, update: .modified)
            try self.realm.commitWrite()
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }

    func read(object: Object.Type) -> [Object] {
        let models = realm.objects(object)

        return Array(models)
    }
    
    func read(object: Object.Type, filter: String) -> [Object] {
        let models = realm.objects(object).filter(filter)

        return Array(models)
    }

    func delete(model: Object) {
        do {
            self.realm.beginWrite()
            self.realm.delete(model)
            try self.realm.commitWrite()
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
}

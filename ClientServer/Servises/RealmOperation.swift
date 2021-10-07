//
//  RealmOperation.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 10.08.2021.
//

import Foundation
import RealmSwift

class RealmOperations {

    func saveFriendsToRealm(_ friendList: [UserModel]) {
        do {
            let realm = try Realm()
            try realm.write{
                let oldFriendList = realm.objects(UserModel.self)
                realm.delete(oldFriendList)
                realm.add(friendList)
            }
        } catch {
            print(error)
        }
    }
    
    func savePhotosToRealm(_ photoList: [PhotoModel], _ ownerID: String) {
        do {
            let realm = try Realm()
            try realm.write {
                let oldPhotoList = realm.objects(PhotoModel.self).filter("ownerID == %@", ownerID)
                realm.delete(oldPhotoList)
                realm.add(photoList)
            }
        } catch {
            print(error)
        }
    }
        
    func saveGroupsToRealm(_ groupList: [GroupModel]) {
        do {
            let realm = try Realm()
            try realm.write{
                let oldGroupList = realm.objects(GroupModel.self)
                realm.delete(oldGroupList)
                realm.add(groupList)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAllFromRealm() {
        do {
            let realm = try Realm()
            try realm.write{
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }
    
}


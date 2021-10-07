//
//  PhotoModel.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 04.07.2021.
//

import Foundation
import DynamicJSON
import RealmSwift

class PhotoModel: Object {
    @objc dynamic var id = 0
    @objc dynamic var albumID = 0
    @objc dynamic var ownerID = 0
    
    @objc dynamic var urlByPhoto = ""
    @objc dynamic var urlByGallery = ""
    
    @objc dynamic var likesCount = 0
    @objc dynamic var userLikes = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(data: JSON) {
        self.init()

        self.id = data.id.int ?? 0
        self.albumID = data.album_id.int ?? 0
        self.ownerID = data.owner_id.int ?? 0
        
        if let sizes = data.sizes.array {
            for size in sizes {
                if size.type.string == "m" {
                    self.urlByPhoto = size.url.string ?? ""
                } else if size.type.string == "x" {
                    self.urlByGallery = size.url.string ?? ""
                }
            }
        }
        
        self.likesCount = data.likes.count.int ?? 0
        self.userLikes = data.likes.user_likes.int ?? 0
    }
}


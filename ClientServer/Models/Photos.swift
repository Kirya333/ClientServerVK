//
//  Photos.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 29.06.2021.
//

import Foundation


struct Photos: Codable {
    let response: ResponsePhotos
}


struct ResponsePhotos: Codable {
    let count: Int
    let items: [Photo]
}


class Photo: Codable {
    @objc dynamic var albumID: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerID: Int = 0
    dynamic var sizes: [Size]
    dynamic var likes: Likes

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case id
        case ownerID = "owner_id"
        case sizes, likes
    }
    
//    override static func ignoredProperties() -> [String] {
//        return ["sizes", "likes"]
//    }
}


class Likes: Codable {
    @objc dynamic var count: Int = 0
    @objc dynamic var userLikes: Int = 0

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}


class Size: Codable {
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""
}

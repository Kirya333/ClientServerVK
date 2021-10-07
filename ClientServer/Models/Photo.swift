//
//  Photo.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 10.09.2021.
//

import Foundation

struct Photo {
    let id: Int
    let albumID: Int
    let ownerID: Int
    let urlByPhoto: String
    let urlByGallery: String
    let likesCount: Int
    let userLikes: Int
}

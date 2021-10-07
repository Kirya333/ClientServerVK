//
//  PhotoModel.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 04.07.2021.
//

import Foundation
import DynamicJSON


class PhotoModel: BaseObject {
    var albumID: Int?
    var id: Int?
    var ownerID: Int?
    var sizes: [SizeModel]?
    var likes: LikesModel?
    
    convenience required init(data: JSON) {
        self.init()

        self.id = data.id.int
        self.albumID = data.album_id.int
        self.ownerID = data.owner_id.int
        self.sizes = data.sizes.array as? [SizeModel]
        self.likes = data.likes.object as? LikesModel
    }
}


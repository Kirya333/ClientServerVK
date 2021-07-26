//
//  FirebaseNews.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 25.07.2021.
//

import Foundation
import DynamicJSON
import Firebase

class FirebaseNews {
    let postId: Int
    let date: Int
    let text: String?
    let commentsCount: Int
    let likesCount: Int
    let userLikes:Int
    let repostsCount: Int
    let viewsCount: Int
    var urlImage: String?
    let ref: DatabaseReference?
    
    init(data: JSON) {
        self.ref = nil
        self.postId = data.post_id.int ?? 0
        self.date = data.date.int ?? 0
        self.text = data.text.string
        self.commentsCount = data.comments.count.int ?? 0
        self.likesCount = data.likes.count.int ?? 0
        self.userLikes = data.likes.user_likes.int ?? 0
        self.repostsCount = data.reposts.count.int ?? 0
        self.viewsCount = data.views.count.int ?? 0
        
        if let attachments = data.attachments.array {
            for attachment in attachments {
                if attachment.type.string == "photo" {
                    if let sizes = attachment.photo.sizes.array {
                        for size in sizes {
                            if size.type.string == "x" {
                                self.urlImage = size.url.string
                            }
                        }
                    }
                }
            }
        }
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let postId = value["postId"] as? Int,
            let date = value["date"] as? Int,
            let commentsCount = value["commentsCount"] as? Int,
            let likesCount = value["likesCount"] as? Int,
            let userLikes = value["userLikes"] as? Int,
            let repostsCount = value["repostsCount"] as? Int,
            let viewsCount = value["viewsCount"] as? Int
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.postId = postId
        self.date = date
        self.text = value["text"] as? String
        self.commentsCount = commentsCount
        self.likesCount = likesCount
        self.userLikes = userLikes
        self.repostsCount = repostsCount
        self.viewsCount = viewsCount
        self.urlImage = value["urlImage"] as? String
    }
    
    func toAnyObject() -> [String: Any?] {
        return [
            "postId": postId,
            "date": date,
            "text": text,
            "commentsCount": commentsCount,
            "likesCount": likesCount,
            "userLikes": userLikes,
            "repostsCount": repostsCount,
            "viewsCount": viewsCount,
            "urlImage": urlImage
        ]
    }
}

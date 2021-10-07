//
//  NewViewModel.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 10.09.2021.
//

import Foundation
import SDWebImage

final class NewViewModel {

    let text: String?
    let image: String?
    let likesCount: String
    let commentsCount: String
    let repostsCount: String
    let viewsCount: String
    var isExpanded: Bool = false
    var heightText: CGFloat = 0
    var aspectRatio: CGFloat
    let likeFlag: Bool
    let likeButtonImage: UIImage
    var images: UIImage?
    
    init(text: String?, image: String?, likesCount: String, commentsCount: String, repostsCount: String, viewsCount: String, aspectRatio: CGFloat, likeFlag: Bool, likeButtonImage: UIImage) {
        self.text = text
        self.image = image
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.repostsCount = repostsCount
        self.viewsCount = viewsCount
        self.aspectRatio = aspectRatio
        self.likeFlag = likeFlag
        self.likeButtonImage = likeButtonImage
    }

    func calculateTextHeight(from width: CGFloat, font: UIFont = .systemFont(ofSize: 17)) {
        let textBlock = CGSize(width: width, height: .greatestFiniteMagnitude)
        let rect = text?.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        self.heightText = ceil(rect?.height ?? 0)
    }
}

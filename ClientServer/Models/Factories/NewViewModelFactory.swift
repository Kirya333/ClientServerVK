//
//  NewViewModelFactory.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 10.09.2021.
//

import Foundation
import SDWebImage

final class NewViewModelFactory {
    func constructViewModels(from news: [FirebaseNews]) -> [NewViewModel] {
        return news.compactMap(self.viewModel)
    }
    
    private func viewModel(from new: FirebaseNews) -> NewViewModel {
        let text = new.text
        let image = new.urlImage
        let likesCount = String(new.likesCount)
        let commentsCount = String(new.commentsCount)
        let repostsCount = String(new.repostsCount)
        let viewsCount = new.viewsCount < 999 ? String(new.viewsCount) : "999+"
        let aspectRatio = CGFloat(new.heightImage ?? 1) / CGFloat(new.widthImage ?? 1)
        let likeFlag = new.userLikes > 0
        let likeButtonImage = likeFlag ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        
        return NewViewModel(text: text,
                            image: image,
                            likesCount: likesCount,
                            commentsCount: commentsCount,
                            repostsCount: repostsCount,
                            viewsCount: viewsCount,
                            aspectRatio: aspectRatio,
                            likeFlag: likeFlag,
                            likeButtonImage: likeButtonImage!)
    }
}

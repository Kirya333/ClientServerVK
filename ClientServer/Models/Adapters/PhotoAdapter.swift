//
//  PhotoAdapter.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 10.09.2021.
//

import Foundation
import RealmSwift


final class PhotoAdapter {
    private let apiVKService = VKService()
    private let realmService = RealmService()
    
    private var token: NotificationToken?
    
    func getPhotos(by userId: Int, then completion: @escaping ([Photo]) -> Void) {
        let realmPhotos = realmService.realm.objects(PhotoModel.self).filter("ownerID == \(userId)")
        
        self.token = realmPhotos.observe { [weak self] changes in
            guard let self = self else { return }
            
            switch changes {
            case .initial(let realmPhotos), .update(let realmPhotos, _, _, _):
                var photos: [Photo] = []
                for realmPhoto in realmPhotos {
                    photos.append(self.photo(from: realmPhoto))
                }
                
                DispatchQueue.main.async {
                    completion(photos)
                }
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
        self.apiVKService.getPhotos(by: userId)
    }
    
    private func photo(from photoModel: PhotoModel) -> Photo {
        return Photo(id: photoModel.id,
                     albumID: photoModel.albumID,
                     ownerID: photoModel.ownerID,
                     urlByPhoto: photoModel.urlByPhoto,
                     urlByGallery: photoModel.urlByGallery,
                     likesCount: photoModel.likesCount,
                     userLikes: photoModel.userLikes)
    }
}



//
//  ApiService.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 29.06.2021.
//

import Foundation
import Alamofire
import DynamicJSON
import FirebaseDatabase

class VKService {
    
    let baseUrl = "https://api.vk.com/method/"
    let version = "5.131"
    let realmService = RealmService()
    
    
    
    func getFriendsList(by userId: Int?, completion: @escaping () -> ()) {
        let method = "friends.get"
        
        var parameters: Parameters = [
            //"order": "name",
            "fields": "photo_50",
            //"name_case": "nom",
            //"list_id": ,
            //"count": "100",
            //"offset": ,
            //"ref": ,
            "access_token": Session.shared.token,
            "v": version
        ]
        
        if let userId = userId {
            parameters["user_id"] = userId
        }
        
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            guard let self = self else { return }
            guard let data = response.value else { return }
            guard let items = JSON(data).response.items.array else { return }

            let friends = items.map { UserModel(data: $0) }
            
            self.realmService.add(models: friends)
            
            completion()
        }
    }
    
    
    
    
    
    func getPhotos(by ownerId: Int, completion: @escaping ([Photo]) -> ()) {
        let method = "photos.get"
        
        let parameters: Parameters = [
            "user_id": ownerId,
            "extended": 1,
            "album_id": "profile",
            //"photo_ids": ,
            "rev": 1,
            //"feed_type": ,
            //"feed": ,
            //"offset": ,
            "count": "10",
            //"photo_sizes": ,
            "access_token": Session.shared.token,
            "v": version
        ]
        
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            guard let self = self else { return }
            guard let data = response.value else { return }
            guard let items = JSON(data).response.items.array else { return }

            let photos = items.map { PhotoModel(data: $0) }
            
            self.realmService.add(models: photos)
            
            }
        }
    
    
    
    
    func getGroupsList(by userId: Int?, completion: @escaping ([Group]) -> ()) {
        let method = "groups.get"
        
        var parameters: Parameters = [
            "extended": 1,
            //"filter": "publics",
            //"fields": ,
            //"offset": ,
            //"count": ,
            "access_token": Session.shared.token,
            "v": version
        ]
        
        if let userId = userId {
            parameters["user_id"] = userId
        }
        
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            guard let self = self else { return }
            guard let data = response.value else { return }
            guard let items = JSON(data).response.items.array else { return }

            let groups = items.map { GroupModel(data: $0) }
            
            self.realmService.add(models: groups)
            
            }
        }
    
    
    
    
    func getGroupsListWith(query: String, completion: @escaping ([GroupModel]) -> ()) {
        let method = "groups.search"
        
        let parameters: Parameters = [
            "q": query,
            //"type": ,
            //"country_id": ,
            //"city_id": ,
            //"future": ,
            //"market": ,
            //"sort": ,
            //"offset": ,
            "count": "100",
            "access_token": Session.shared.token,
            "v": version
        ]
        
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            guard let items = JSON(data).response.items.array else { return }

            let groups = items.map { GroupModel(data: $0) }
            
            DispatchQueue.main.async {
                completion(groups)
            }
        }
    }
    
    func getNewsfeed() {
        let method = "newsfeed.get"
        let ref = Database.database().reference(withPath: "news")
        
        let parameters: Parameters = [
            "filters": "post",
            //"return_banned": ,
            //"start_time": ,
            //"end_time": ,
            //"max_photos": ,
            //"source_ids": ,
            //"start_from": ,
            "count": "10",
            //"fields": ,
            //"section": ,
            "access_token": Session.shared.token,
            "v": version
        ]
        
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            guard let items = JSON(data).response.items.array else { return }
            
            for new in items {
                let new = FirebaseNews(data: new)
                let newRef = ref.child(Session.shared.userId).child(String(new.postId))
                newRef.setValue(new.toAnyObject())
            }
        }
    }
    
}

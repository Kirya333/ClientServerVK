//
//  ApiService.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 29.06.2021.
//

import Foundation
import Alamofire

class VKService {
    
    let baseUrl = "https://api.vk.com/method/"
    let version = "5.131"
    
    
    
    func getFriendsList(by userId: Int?, completion: @escaping ([Friend]) -> ()) {
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
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            let friendsResponse = try? JSONDecoder().decode(Friends.self, from: data).response
            guard let friends = friendsResponse?.items else { return }
            DispatchQueue.main.async {
                completion(friends)
            }
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
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            let photosResponse = try? JSONDecoder().decode(Photos.self, from: data).response
            guard let photos = photosResponse?.items else { return }
            DispatchQueue.main.async {
                completion(photos)
            }
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
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            let groupsResponse = try? JSONDecoder().decode(Groups.self, from: data).response
            guard let groups = groupsResponse?.items else { return }
            DispatchQueue.main.async {
                completion(groups)
            }
        }
    }
    
    
    
    
    func getGroupsListWith(query: String, completion: @escaping ([Group]) -> ()) {
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
            let groupsResponse = try? JSONDecoder().decode(Groups.self, from: data).response
            guard let groups = groupsResponse?.items else { return }
            DispatchQueue.main.async {
                completion(groups)
            }
        }
    }
}

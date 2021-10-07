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
import PromiseKit

class VKService {
    
    let baseUrl = "https://api.vk.com/method/"
    let version = "5.131"
    let realmService = RealmService()
    let dispatchGroup = DispatchGroup()
    let myQueue = OperationQueue()
    
    
    
    
    
    func getFriendsList(by userId: Int?) {
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
        
//        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
//            guard let self = self else { return }
//            guard let data = response.value else { return }
//            guard let items = JSON(data).response.items.array else { return }
//
//            let friends = items.map { UserModel(data: $0) }
//            
//            self.realmService.add(models: friends)
//        }
        
        let request = AF.request(url, method: .get, parameters: parameters)
        let getDataOperation = GetDataOperation(request: request)
        myQueue.addOperation(getDataOperation)
        
        let parseData = ParseFriendsData()
        parseData.addDependency(getDataOperation)
        myQueue.addOperation(parseData)
        
        let saveData = SaveDataToRealm()
        saveData.addDependency(parseData)
        OperationQueue.main.addOperation(saveData)
        
    }
    
    
    
    
    
    func getPhotos(by ownerId: Int) {
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
    
    
    
    
    func getGroupsList(by userId: Int?) -> Promise<[GroupModel]> {
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
        
//        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
//            guard let self = self else { return }
//            guard let data = response.value else { return }
//            guard let items = JSON(data).response.items.array else { return }
//
//            let groups = items.map { GroupModel(data: $0) }
//
//            self.realmService.add(models: groups)
        
        let promise = Promise <[GroupModel]> { resolver in
            AF.request(url, method: .get, parameters: parameters).responseData { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    if let errorMessage = json.error.error_msg.string {
                        let error = VKServiceError.generalError(message: errorMessage)
                            resolver.reject(error)
                                return
                    }
                    guard let items = JSON(value).response.items.array else { return }
                    let groups = items.map { GroupModel(data: $0)}
                    resolver.fulfill(groups)
                    
                case .failure(let error):
                    resolver.reject(error)
                    return
                        }
                    }
                }
        return promise
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
    
    func getNewsfeed(startTime: Int? = nil, startFrom: String? = nil, completion: @escaping (String) -> ()) {
        let method = "newsfeed.get"
        let ref = Database.database().reference(withPath: "news")
        
        var parameters: Parameters = [
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
        
        if let startTime = startTime {
            parameters["start_time"] = startTime
        }
        
        if let startFrom = startFrom {
            parameters["start_from"] = startFrom
        }
        
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            guard let self = self else { return }
            guard let data = response.value else { return }
            guard let items = JSON(data).response.items.array else { return }
            
            let profiles = JSON(data).response.profiles.array ?? []
            let groups = JSON(data).response.groups.array ?? []
            let nextFrom = JSON(data).response.next_from.string ?? ""
            
            for new in items {
                
                DispatchQueue.global().async(group: self.dispatchGroup) {
                    print("new \(JSON(new).post_id.int ?? 0)")
                    let new = FirebaseNews(data: new)
                    let newRef = ref.child(Session.shared.userId).child(String(new.postId))
                    newRef.setValue(new.toAnyObject())
                }
            }
            
            for profile in profiles {
                DispatchQueue.global().async(group: self.dispatchGroup) {
                    print("profile \(JSON(profile).id.int ?? 0)")
                }
            }
            
            for group in groups {
                DispatchQueue.global().async(group: self.dispatchGroup) {
                    print("group \(JSON(group).id.int ?? 0)")
                }
            }
            
            self.dispatchGroup.notify(queue: .global()) {
                DispatchQueue.main.async {
                    completion(nextFrom)
                }
            }
            
        }
    }
    
}

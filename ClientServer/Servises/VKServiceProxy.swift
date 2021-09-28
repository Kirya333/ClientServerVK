//
//  VKServiceProxy.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 28.09.2021.
//

import Foundation
import PromiseKit

class VKServiceProxy: VKServiceInterface {
    let apiVKService: VKService
    
    init(_ service: VKService) {
        self.apiVKService = service
    }

    func getFriendsList(by userId: Int?) {
        print("Logging request: Getting a list of friends")
        print("Parameters: userId = \(userId ?? 0)")
        
        self.apiVKService.getFriendsList(by: userId)
    }
    
    func getPhotos(by ownerId: Int) {
        print("Logging request: Getting a list of photos")
        print("Parameters: ownerId = \(ownerId)")
        
        self.getPhotos(by: ownerId)
    }
    
    func getGroupsList(by userId: Int?) -> Promise<[GroupModel]> {
        print("Logging a request: Getting a list of groups")
        print("Parameters: userId = \(userId ?? 0)")
        
        return self.apiVKService.getGroupsList(by: userId)
    }
    
    func getGroupsListWith(query: String, completion: @escaping ([GroupModel]) -> ()) {
        print("Logging a request: Getting a list of groups on request")
        print("Parameters: query = \(query)")
        
        self.apiVKService.getGroupsListWith(query: query, completion: completion)
    }
    
    func getNewsfeed(startTime: Int? = nil, startFrom: String? = nil, completion: @escaping (String) -> ()) {
        print("Logging a request: Getting a list of news")
        print("Parameters: startTime = \(startTime ?? 0), startFrom = \(startFrom ?? "")")
        
        self.apiVKService.getNewsfeed(startTime: startTime, startFrom: startFrom, completion: completion)
    }
}

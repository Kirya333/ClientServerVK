//
//  UserAdapter.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 10.09.2021.
//

import Foundation
import RealmSwift

final class UserAdapter {
    
    private let apiVKService = VKService()
    private let realmService = RealmService()
    
    private var token: NotificationToken?
    
    func getFriends(by userId: Int?, then completion: @escaping ([User]) -> Void) {
        let realmFriends = realmService.realm.objects(UserModel.self)
        
        self.token = realmFriends.observe { [weak self] changes in
            guard let self = self else { return }
            
            switch changes {
            case .initial(let realmFriends), .update(let realmFriends, _, _, _):
                var friends: [User] = []
                for realmFriend in realmFriends {
                    friends.append(self.user(from: realmFriend))
                }
                
                DispatchQueue.main.async {
                    completion(friends)
                }
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
        self.apiVKService.getFriendsList(by: userId)
    }
    
    private func user(from userModel: UserModel) -> User {
        return User(id: userModel.id,
                    lastName: userModel.lastName,
                    firstName: userModel.firstName,
                    avatar: userModel.avatar)
    }
}

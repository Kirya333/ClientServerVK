//
//  GroupAdapter.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 10.09.2021.
//

import Foundation
import RealmSwift
import PromiseKit


final class GroupAdapter {
    
    private let apiService = VKService()
    private let realmService = RealmService()
    
    private var token: NotificationToken?
    
    func getGroups(by userId: Int?, then competion: @escaping ([Group]) -> Void) {
        
        var realmGroups: Results<GroupModel>?
        
        firstly {
            self.apiService.getGroupsList(by: userId)
        } .get { [weak self] groups in
            guard let self = self else { return }
            self.realmService.add(models: groups)
        } . catch { error in
            fatalError("\(error)")
        } .finally { [weak self] in
            guard let self = self else { return }
            realmGroups = self.realmService.realm.objects(GroupModel.self)
            
            self.token = realmGroups?.observe { [weak self] changes in
                guard let self = self else { return }
                
                switch changes {
                case .initial(let realmGroups), .update(let realmGroups, _, _, _):
                    var groups: [Group] = []
                    for realmGroup in realmGroups {
                        groups.append(self.group(from: realmGroup))
                    }
                    
                    DispatchQueue.main.async {
                        competion(groups)
                    }
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        }
    }
    
    func getGroupsListWith(query: String, then completion: @escaping ([Group]) -> Void) {
        self.apiService.getGroupsListWith(query: query) { [weak self] realmGroups in
            guard let self = self else { return }
            var groups: [Group] = []
            for realmGroup in realmGroups {
                groups.append(self.group(from: realmGroup))
            }
            
            DispatchQueue.main.async {
                completion(groups)
            }
        }
    }
    
    private func group(from groupModel: GroupModel) -> Group {
        return Group(id: groupModel.id,
                          name: groupModel.name,
                          avatar: groupModel.avatar)
    }
}



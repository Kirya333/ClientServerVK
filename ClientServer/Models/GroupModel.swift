//
//  GroupModel.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 04.07.2021.
//

import Foundation
import DynamicJSON


class GroupModel: BaseObject {
    var id: Int?
    var name: String?
    var avatar: String?
    
    convenience required init(data: JSON) {
        self.init()
        
        self.id = data.id.int
        self.name = data.name.string
        self.avatar = data.photo_50.string
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        
        if let other = object as? Group {
            return self.id == other.id
        }
        
        return false
        
    }
}



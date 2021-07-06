//
//  BaseModel.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 04.07.2021.
//

import Foundation
import DynamicJSON
import RealmSwift


public class BaseObject: Object {

    convenience required init(data: JSON) {
        self.init()
    }
}



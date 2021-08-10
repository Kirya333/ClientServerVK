//
//  ParseFriendsData.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 10.08.2021.
//

import Foundation
import DynamicJSON


class ParseFriendsData: Operation {
    
    var outputData: [UserModel] = []
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
              let data = getDataOperation.data,
              let items = JSON(data).response.items.array else { return }
        
        let friends = items.map { UserModel(data: $0)}
        
        outputData = friends
        
    }
}

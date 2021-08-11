//
//  VKServiceError.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 10.08.2021.
//

import Foundation


enum VKServiceError: Error {
     case generalError(message: String)

     var localizedDescription: String {
         switch self {
         case .generalError(message: let message):
             return "Ошибка: \(message)"
         }
     }
 }

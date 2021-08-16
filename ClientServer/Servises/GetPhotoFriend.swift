//
//  GetPhotoFriend.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 09.08.2021.
//

import Foundation


struct PhotosResponse: Decodable {
    var response: Response
    
    struct Response: Decodable {
        var count: Int
        var items: [Item]
        
        struct Item: Decodable {
            var ownerID: Int
            var sizes: [Sizes]
            
            private enum CodingKeys: String, CodingKey {
                case ownerID = "owner_ID"
                case sizes
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                ownerID = try container.decode(Int.self, forKey: .ownerID)
                sizes = try container.decode([Sizes].self, forKey: .sizes)
            }
            
            struct Sizes: Decodable {
                var url: String
            }
        }
    }
}



//class GetPhotoFriend {
//
//
//    func loadData(_ownerID: String) {
//
//        let configuration = URLSessionConfiguration.default
//
//        let session = URLSession(configuration: configuration)
//
//        var urlConstructor = URLComponents()
//        urlConstructor.scheme = "https"
//        urlConstructor.host = "api.vk.com"
//        urlConstructor.path = "/method/photos.getAll"
//        urlConstructor.queryItems = [
//            URLQueryItem(name: "owner_id", value: _ownerID),
//            URLQueryItem(name: "access_token", value: Session.shared.token),
//            URLQueryItem(name: "v", value: "5.131")
//        ]
//
//        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
//            guard let data = data else { return }
//
//            do {
//                let arrayPhotosFriend = try JSONDencoder().decode(PhotosResponse.self, from: data)
//                var photosFriend: [PhotoModel] = []
//                var ownerID = ""
//
//                for i in 0...arrayPhotosFriend.rspponse.items.count-1 {
//                    if let urlPhoto = arrayPhotosFriend.response.items[i].sizes.last?.url {
//                        ownerID = String(arrayPhotosFriend.response.items[i].ownerID)
//                        photosFriend.append(Photo.init(photo: urlPhoto, ownerID: ownerID))
//                    }
//                }
//                DispatchQueue.main.async {
//                    RealmOperations().savePhotosToRealm(photosFriend, ownerID)
//                }
//            } catch let error {
//                print(error)
//            }
//        }
//        task.resume()
//    }
//}

//
//  FriendsListController.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 10.07.2021.
//

import UIKit

class FriendsListController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var friendsTableView: UITableView!
    
    
    let friendTableViewCellIdentifier = "FriendTableViewCellIdentifier"
    let fromFriendsListToFriendsPhotosSegueIdentifier = "fromFriendsListToFriendsPhotos"
    
//    let apiService = VKService()
//    let realmService = RealmService()
    let apiService = UserAdapter()
    
    var friends = [User]()
    var searchFriends = [User]()
    
    var searchFlag = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiService.getFriends(by: nil) { [ weak self] friends in
            guard let self = self else { return }
            self.friends = friends
            self.friendsTableView.reloadData()
        }
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: friendTableViewCellIdentifier)
        searchBar.delegate = self
        
    }
    
//    func setFriends() {
//        apiService.getFriendsList(by: nil)
//
//                 if let friends = self.realmService.read(object: UserModel.self) as? [UserModel] {
//                     self.friends = friends
//                     self.friendsTableView.reloadData()
//            }
//        }
    
    func getMyFriends() -> [User] {
        if searchFlag {
            return searchFriends
        }
        
        return friends
    }

    
    
    func arrayLetter() -> [String] {
        var resultArray = [String]()
        
        for friend in getMyFriends() {
            let nameLetter = String(friend.getFullName().prefix(1))
            if !resultArray.contains(nameLetter) {
                resultArray.append(nameLetter)
            }
        }
        resultArray = resultArray.sorted(by: <)
        
        return resultArray
    }
    
    func arrayByLetter(letter: String) -> [User] {
        var resultArray = [User]()
        
        for friend in getMyFriends() {
            let nameLetter = String(friend.getFullName().prefix(1))
            if nameLetter == letter {
                resultArray.append(friend)
            }
        }
        
        return resultArray
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromFriendsListToFriendsPhotos" {
            guard let friendsPhotosViewController = segue.destination as? FriendsPhotosViewController
            else { return }

            guard let indexPath = sender as? IndexPath else { return }
            let friend = arrayByLetter(letter: arrayLetter()[indexPath.section])[indexPath.row]

            friendsPhotosViewController.friendID = friend.id

        }
    }

}

extension FriendsListController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayLetter().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayByLetter(letter: arrayLetter()[section]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: friendTableViewCellIdentifier, for: indexPath) as? FriendTableViewCell
        else {
            return UITableViewCell()
        }
        
        let arrayByLetter = arrayByLetter(letter: arrayLetter()[indexPath.section])
        let friend = arrayByLetter[indexPath.row]
        
        cell.configure(user: friend)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: fromFriendsListToFriendsPhotosSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrayLetter()[section].uppercased()
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return arrayLetter()
    }
}

extension FriendsListController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchFlag = false
        } else {
            searchFlag = true
            searchFriends = friends.filter({
                $0.getFullName().lowercased().contains(searchText.lowercased())
            })
        }
        friendsTableView.reloadData()
    }
    
}

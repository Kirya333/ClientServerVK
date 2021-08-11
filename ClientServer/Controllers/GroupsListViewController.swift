//
//  GroupsListViewController.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 16.07.2021.
//

import UIKit
import RealmSwift
import FirebaseDatabase
import PromiseKit


class GroupsListViewController: UIViewController {
    
    @IBOutlet weak var groupsListTableView: UITableView!
    
    let groupTableViewCellIdentifier = "GroupTableViewCellIdentifier"
    let addGroupSegueIdentifier = "addGroup"
    
    let apiService = VKService()
    let realmService = RealmService()
    
    var token: NotificationToken?
    
    private var ref = Database.database().reference(withPath: "userGroups")
    
    var groups: Results<GroupModel>? {
        didSet {
            token = groups?.observe { [weak self] changes in
                guard let self = self else { return }
                
                switch changes {
                case .initial:
                    self.groupsListTableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self.groupsListTableView.beginUpdates()
                    self.groupsListTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    self.groupsListTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    self.groupsListTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    self.groupsListTableView.endUpdates()
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGroups()
        
        groupsListTableView.dataSource = self
        groupsListTableView.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: groupTableViewCellIdentifier)
    }
    
    func setGroups() {
//        //apiService.getGroupsList(by: nil, completion: ([Group]) -> ())
//        apiService.getGroupsList(by: nil) { groups in
//        }
//        guard let realm = try? Realm() else { return }
//        groups = realm.objects(GroupModel.self)
        
        firstly {
            apiService.getGroupsList(by: nil)
        } .get { [weak self] groups in
            guard let self = self else { return }
            self.realmService.add(models: groups)
        } .catch { [weak self] error in
            guard let self = self else { return }
            self.showError(error.localizedDescription)
        } .finally { [weak self] in
            guard let self = self else { return }
            guard let realm = try? Realm() else { return }
            self.groups = realm.objects(GroupModel.self)
        }
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "warning!", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == addGroupSegueIdentifier {
            guard let groupSearchViewController = segue.source as? GroupsSearchViewController else { return }
            
            if let indexPath = groupSearchViewController.groupsSearchTableView.indexPathForSelectedRow {
                let group = groupSearchViewController.searchGroups[indexPath.row]
                
                realmService.add(models: [group])
                
                let groupAdded = FirebaseGroupAdded(id: group.id, name: group.name, avatar: group.avatar)
                let groupRef = self.ref.child(Session.shared.userId).child(group.name)
                groupRef.setValue(groupAdded.toAnyObject())
                }
            }
        }
    }

extension GroupsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: groupTableViewCellIdentifier, for: indexPath) as? GroupTableViewCell
        else {
            return UITableViewCell()
        }
        
        if let group = groups?[indexPath.row] {
            cell.configure(group: group)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if let group = groups?[indexPath.row], editingStyle == .delete {
            realmService.delete(model: group)
        }
    }
}

//
//  GroupsListViewController.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 16.07.2021.
//

import UIKit

class GroupsListViewController: UIViewController {
    
    @IBOutlet weak var groupsListTableView: UITableView!
    
    let groupTableViewCellIdentifier = "GroupTableViewCellIdentifier"
    let addGroupSegueIdentifier = "addGroup"
    
    let apiService = VKService()
    
    var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGroups()
        
        groupsListTableView.dataSource = self
        groupsListTableView.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: groupTableViewCellIdentifier)
    }
    
    func setGroups() {
        apiService.getGroupsList(by: nil) { [weak self] groups in
            guard let self = self else { return }
            self.groups = groups
            self.groupsListTableView.reloadData()
        }
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == addGroupSegueIdentifier {
            guard let groupSearchViewController = segue.source as? GroupsSearchViewController else { return }
            if let indexPath = groupSearchViewController.groupsSearchTableView.indexPathForSelectedRow {
                let group = groupSearchViewController.searchGroups[indexPath.row]
                
                if !groups.contains(group) {
                    groups.append(group)
                    groupsListTableView.reloadData()
                }
            }
        }
    }
}

extension GroupsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: groupTableViewCellIdentifier, for: indexPath) as? GroupTableViewCell
        else {
            return UITableViewCell()
        }
        
        let group = groups[indexPath.row]
        
        cell.configure(group: group)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

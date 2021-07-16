//
//  NewsListViewController.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 16.07.2021.
//

import UIKit

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    let newsTableViewCellIdentifier = "NewsTableViewCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsTableView.dataSource = self
        newsTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: newsTableViewCellIdentifier)
        
    }
}

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStorage.shared.newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: newsTableViewCellIdentifier, for: indexPath) as? NewsTableViewCell
        else {
            return UITableViewCell()
        }
        
        let new = DataStorage.shared.newsArray[indexPath.row]

        cell.configure(news: new)
        
        return cell
    }
}

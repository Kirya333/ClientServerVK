//
//  NewsListViewController.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 16.07.2021.
//

import UIKit
import FirebaseDatabase

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    let newsTableViewCellImageIdentifier = "NewsTableViewCellImageIdentifier"
    let newsTableViewCellTextIdentifier = "NewsTableViewCellTextIdentifier"
    let newsTableViewCellCountersIdentifier = "NewsTableViewCellCountersIdentifier"
    
    let apiService = VKService()
    
    private var news = [FirebaseNews]()
    private let ref = Database.database().reference(withPath: "news/\(Session.shared.userId)")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNews()
        
        newsTableView.dataSource = self
        newsTableView.register(UINib(nibName: "NewsTableViewImageCell", bundle: nil), forCellReuseIdentifier: newsTableViewCellImageIdentifier)
        newsTableView.register(UINib(nibName: "NewsTableViewTextCell", bundle: nil), forCellReuseIdentifier: newsTableViewCellTextIdentifier)
        newsTableView.register(UINib(nibName: "NewsTableViewCountersCell", bundle: nil), forCellReuseIdentifier: newsTableViewCellCountersIdentifier)
        
    }
    
    func setNews() {
        apiService.getNewsfeed()
        
        ref.observe(.value, with: { [weak self] snapshot in
            guard let self = self else { return }
            var news: [FirebaseNews] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let new = FirebaseNews(snapshot: snapshot) {
                       news.append(new)
                }
            }
            
            self.news = news
            self.newsTableView.reloadData()
        })
    }
    
}

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsSection section: Int) -> Int {
        var rows = 1
        if news[section].text != nil { rows += 1 }
        if news[section].urlImage != nil { rows += 1}
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let new = DataStorage.shared.newsArray[indexPath.row]
        
        if new.text != nil && indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: newsTableViewCellTextIdentifier, for: indexPath) as? NewsTableViewTextCell
            else {
                return UITableViewCell()
            }
            cell.configure(news: new)
            
            return cell
            
        } else if new.urlImage != nil && indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: newsTableViewCellImageIdentifier, for: indexPath) as? NewsTableViewImageCell
            else {
                return UITableViewCell()
            }
            cell.configure(news: new)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: newsTableViewCellCountersIdentifier, for: indexPath) as? NewsTableViewCountersCell
            else {
                return UITableViewCell()
            }
            cell.configure(news: new)
            
            return cell
        }
    }
}

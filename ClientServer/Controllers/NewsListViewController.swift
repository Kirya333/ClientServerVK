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
    
    let newsTableViewCellIdentifier = "NewsTableViewCellIdentifier"
    
    let apiService = VKService()
    
    private var news = [FirebaseNews]()
    private let ref = Database.database().reference(withPath: "news/\(Session.shared.userId)")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNews()
        
        newsTableView.dataSource = self
        newsTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: newsTableViewCellIdentifier)
        
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

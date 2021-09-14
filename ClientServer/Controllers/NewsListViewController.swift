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
    
    private let viewModelFactory = NewViewModelFactory()
    private var viewModels = [NewViewModel]()
    
    var nextFrom = ""
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNews()
        setupRefreshControl()
        
        
        newsTableView.dataSource = self
        newsTableView.prefetchDataSource = self
        newsTableView.delegate = self
        newsTableView.allowsSelection = false
        
        newsTableView.register(UINib(nibName: "NewsTableViewImageCell", bundle: nil), forCellReuseIdentifier: newsTableViewCellImageIdentifier)
        newsTableView.register(UINib(nibName: "NewsTableViewTextCell", bundle: nil), forCellReuseIdentifier: newsTableViewCellTextIdentifier)
        newsTableView.register(UINib(nibName: "NewsTableViewCountersCell", bundle: nil), forCellReuseIdentifier: newsTableViewCellCountersIdentifier)
        
    }
    
    fileprivate func setupRefreshControl() {
        newsTableView.refreshControl = UIRefreshControl()
        newsTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        newsTableView?.tintColor = Styles.brandLightBlue
        newsTableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc func refreshNews() {
        newsTableView.refreshControl?.beginRefreshing()
        
        let mostFreshNewsDate = self.news.first?.date ?? Int(Date().timeIntervalSince1970)
        
        apiService.getNewsfeed(startTime: mostFreshNewsDate) { [weak self] nextFrom in
            guard let self = self else { return }
            self.nextFrom = nextFrom
        }
        
        newsTableView.refreshControl?.endRefreshing()
        
    }
    
    func setNews() {
        apiService.getNewsfeed() { [weak self] nextFrom in
            guard let self = self else { return }
            self.nextFrom = nextFrom
            
        }
        
        ref.observe(.value, with: { [weak self] snapshot in
            guard let self = self else { return }
            var news: [FirebaseNews] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let new = FirebaseNews(snapshot: snapshot) {
                       news.append(new)
                }
            }
            
            news.sort(by: { $0.date > $1.date })
            
            self.news = news
            self.viewModels = self.viewModelFactory.constructViewModels(from: news)
            self.viewModels.forEach({ $0.calculateTextHeight(from: self.view.frame.width)})
            self.newsTableView.reloadData()
        })
    }
    
}

extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 1
        if viewModels[section].text != nil { rows += 1}
        if viewModels[section].image != nil { rows += 1}
        return rows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let new = viewModels[indexPath.section]
        
        if new.text != nil && indexPath.row == 0 {

            if new.heightText < NewsTableViewTextCell.defaultTextHeight {
                return new.heightText + NewsTableViewTextCell.smallIndent
            } else if new.isExpanded {
                return new.heightText + NewsTableViewTextCell.buttonHeight + NewsTableViewTextCell.smallIndent * 2
            } else {
                return NewsTableViewTextCell.defaultTextHeight + NewsTableViewTextCell.buttonHeight + NewsTableViewTextCell.smallIndent * 2
            }
        } else if (new.text == nil && new.image != nil && indexPath.row == 0 ) ||
            (new.text != nil && new.image != nil && indexPath.row == 1) {
            let tableWidth = tableView.bounds.width
            let cellHeight = tableWidth * new.aspectRatio + NewsTableViewImageCell.smallIndent
            return cellHeight
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let new = viewModels[indexPath.section]
        
        if new.text != nil && indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: newsTableViewCellTextIdentifier, for: indexPath) as? NewsTableViewTextCell
            else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(news: new)
            
            return cell
        } else if new.image != nil && indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: newsTableViewCellImageIdentifier, for: indexPath) as? NewsTableViewImageCell
            else {
                return UITableViewCell()
            }
            cell.configure(news: new)

            return cell
        } else if new.text != nil && new.image != nil && indexPath.row == 1 {
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


extension NewsListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        
        if maxSection > viewModels.count - 3, !isLoading {
            isLoading = true
            
            apiService.getNewsfeed(startFrom: nextFrom) { [weak self] nextFrom in
                guard let self = self else { return }
                self.nextFrom = nextFrom
                
                self.isLoading = false
                
            }
        }
    }
}

extension NewsListViewController: NewsTableViewTextCellDelegate {
    func showMoreAction(cell: NewsTableViewTextCell) {
        guard let indexPath = newsTableView.indexPath(for: cell) else { return }
        let new = viewModels[indexPath.section]
        
        new.isExpanded = !new.isExpanded
        newsTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

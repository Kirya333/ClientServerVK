//
//  NewsTableViewCountersCell.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 16.08.2021.
//

import UIKit

class NewsTableViewCountersCell: UITableViewCell {
    
    var likeFlag = false
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var countLikesLabel: UILabel!
    @IBOutlet weak var countCommentsLabel: UILabel!
    @IBOutlet weak var countRepostsLabel: UILabel!
    @IBOutlet weak var countViewsLabel: UILabel!
    
    @IBAction func tapLikeButton(_ sender: Any) {
        if likeFlag {
            likeFlag = false
            countLikesLabel.text = String(Int(countLikesLabel.text!)! - 1)
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            likeFlag = true
            countLikesLabel.text = String(Int(countLikesLabel.text!)! + 1)
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    func setup() {
        
    }
    
    func clearCell() {
        countLikesLabel.text = nil
        countViewsLabel.text = nil
        countRepostsLabel.text = nil
        countCommentsLabel.text = nil
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeFlag = false
    }
    
    func configure(news: FirebaseNews) {
        countLikesLabel.text = String(news.likesCount)
        countCommentsLabel.text = String(news.commentsCount)
        countRepostsLabel.text = String(news.repostsCount)
        countViewsLabel.text = String(news.viewsCount)
        
        if news.userLikes > 0 {
            likeFlag = true
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    override func prepareForReuse() {
        clearCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        clearCell()
    }
}

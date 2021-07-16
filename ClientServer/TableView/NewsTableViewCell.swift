//
//  NewsTableViewCell.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 15.07.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    var likeFlag = false
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var countLikesLabel: UILabel!
    @IBOutlet weak var countCommentsLabel: UILabel!
    @IBOutlet weak var countRepostsLabel: UILabel!
    @IBOutlet weak var countViewsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    
    func setup() {
        
    }
    
    func clearCell() {
        
    }
    
    func configure(news:News) {
        
    }
    
    override func prepareForReuse() {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

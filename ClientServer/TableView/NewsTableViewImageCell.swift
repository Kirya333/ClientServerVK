//
//  NewsTableViewImageCell.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 16.08.2021.
//

import UIKit

class NewsTableViewImageCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    func setup() {
        
    }
    
    func clearCell() {
        photoImageView.image = nil
    }
    
    func configure(news: FirebaseNews) {
        if let image = news.urlImage {
            photoImageView.sd_setImage(with: URL(string: image))
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

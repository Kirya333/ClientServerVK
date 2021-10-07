//
//  NewsTableViewImageCell.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 16.08.2021.
//

import UIKit

class NewsTableViewImageCell: UITableViewCell {
    
    static let smallIndent: CGFloat = 5.0

    @IBOutlet weak var photoImageView: UIImageView! {
        didSet {
            photoImageView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func photoImageViewFrame(height: CGFloat) {
        photoImageView.frame = CGRect(x: 0, y: NewsTableViewImageCell.smallIndent, width: contentView.frame.width, height: height)
    }
    
    func setup() {
        
    }
    
    func clearCell() {
        photoImageView.image = nil
    }
    
    func configure(news: FirebaseNews) {
        if let image = news.urlImage {
            photoImageView.sd_setImage(with: URL(string: image))
        }
        
        let height = contentView.frame.width * news.apectRatio
        photoImageViewFrame(height: height)
        
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

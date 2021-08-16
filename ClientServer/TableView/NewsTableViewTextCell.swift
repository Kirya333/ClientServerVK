//
//  NewsTableViewTextCell.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 16.08.2021.
//

import UIKit

class NewsTableViewTextCell: UITableViewCell {

    @IBOutlet weak var TextLabel: UILabel!
    
    func setup() {
        
    }
    
    func clearCell() {
        TextLabel.text = nil
    }
    
    func configure(news: FirebaseNews) {
        if let textOfLabel = news.text {
            TextLabel.text = textOfLabel
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

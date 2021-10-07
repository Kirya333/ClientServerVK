//
//  NewsTableViewTextCell.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 16.08.2021.
//

import UIKit

protocol NewsTableViewTextCellDelegate {
    func showMoreAction(cell: NewsTableViewTextCell)
}

class NewsTableViewTextCell: UITableViewCell {

    var delegate: NewsTableViewTextCellDelegate?
    
    static let smallIndent: CGFloat = 5.0
    
    static let buttonWidth: CGFloat = 100.0
    static let buttonHeight: CGFloat = 20.0
    
    static let defaultTextHeight: CGFloat = 200.0
    
    @IBOutlet weak var showMoreOrLessButton: UIButton! {
        didSet {
            showMoreOrLessButton.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var TextLabel: UILabel! {
        didSet {
            TextLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBAction func showMoreOrLessAction(_ sender: Any) {
        delegate?.showMoreAction(cell: self)
    }
    
    func textLabelFrame(height: CGFloat) {
        TextLabel.frame = CGRect(x: NewsTableViewTextCell.smallIndent, y: NewsTableViewTextCell.smallIndent, width: contentView.frame.width - NewsTableViewTextCell.smallIndent * 2, height: height)
    }
    
    func showMoreButtonFrame(title: String) {
        showMoreOrLessButton.frame = CGRect(x: NewsTableViewTextCell.smallIndent, y: TextLabel.frame.maxY + NewsTableViewTextCell.smallIndent, width: NewsTableViewTextCell.buttonWidth, height: NewsTableViewTextCell.buttonHeight)
        showMoreOrLessButton.isHidden = false
        showMoreOrLessButton.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.1022562769, alpha: 1)
        showMoreOrLessButton.setTitle(title, for: .normal)
    }
    
    func setup() {
        
    }
    
    func clearCell() {
        TextLabel.text = nil
        showMoreOrLessButton.isHidden = true
    }
    
    func configure(news: FirebaseNews) {
        if let textOfLabel = news.text {
            TextLabel.text = textOfLabel
            
            if news.heightText < NewsTableViewTextCell.defaultTextHeight || news.isExpanded {
                textLabelFrame(height: news.heightText)
                if news.isExpanded {
                    showMoreButtonFrame(title: "Hide")
                }
            } else {
                textLabelFrame(height: NewsTableViewTextCell.defaultTextHeight)
                showMoreButtonFrame(title: "Show")
            }
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

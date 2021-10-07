//
//  NewsTableViewCountersCell.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 16.08.2021.
//

import UIKit

class NewsTableViewCountersCell: UITableViewCell {
    
    var likeFlag = false
    
    let smallIndent: CGFloat = 5.0
    let mediumIndent: CGFloat = 15.0
    let largeIndent: CGFloat = 30.0
    let height: CGFloat = 20.0
    let buttonWidth: CGFloat = 20.0
    let seporationHeight: CGFloat = 1.0
    
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            likeButton.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var countLikesLabel: UILabel! {
        didSet {
            countLikesLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var countCommentsLabel: UILabel! {
        didSet {
            countCommentsLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var countRepostsLabel: UILabel! {
        didSet {
            countRepostsLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var countViewsLabel: UILabel! {
        didSet {
            countViewsLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var commentButton: UIButton! {
        didSet {
            commentButton.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var repostsButton: UIButton! {
        didSet {
            repostsButton.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var viewImage: UIImageView! {
        didSet {
            viewImage.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
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
        countLikesLabelFrame()
    }
    
    func getLAbelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = (bounds.width - largeIndent * 2 - mediumIndent * 2 - smallIndent * 4 - buttonWidth * 4) / 4
        let textBlock = CGSize(width: maxWidth, height: self.height)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func likeButtonFrame() {
        likeButton.frame = CGRect(x: mediumIndent, y: smallIndent, width: buttonWidth, height: height)
    }
    
    func countLikesLabelFrame() {
        let labelSize = getLAbelSize(text: countLikesLabel.text!, font: countLikesLabel.font)
        let labelOrigin = CGPoint(x: likeButton.frame.maxX + smallIndent, y: smallIndent)
        countLikesLabel.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    func commentButtonFrame() {
        commentButton.frame = CGRect(x: countLikesLabel.frame.maxX + largeIndent, y: smallIndent, width: buttonWidth, height: height)
    }
    
    func countCommentsLabelFrame() {
        let labelSize = getLAbelSize(text: countCommentsLabel.text!, font: countCommentsLabel.font)
        let labelOrigin = CGPoint(x: commentButton.frame.maxX + smallIndent, y: smallIndent)
        countCommentsLabel.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    func repostsButtonFrame() {
        repostsButton.frame = CGRect(x: countCommentsLabel.frame.maxX + largeIndent, y: smallIndent, width: buttonWidth, height: height)
    }
    
    func countRepostsLabelFrame() {
        let labelSize = getLAbelSize(text: countRepostsLabel.text!, font: countRepostsLabel.font)
        let labelOrigin = CGPoint(x: repostsButton.frame.maxX + smallIndent, y: smallIndent)
        countRepostsLabel.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    func countViewsLabelFrame() {
        let labelSize = getLAbelSize(text: countViewsLabel.text!, font: countViewsLabel.font)
        let labelOrigin = CGPoint(x: contentView.bounds.maxX - mediumIndent - labelSize.width, y: smallIndent)
        countViewsLabel.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    func viewImageFrame() {
        viewImage.frame = CGRect(x: countViewsLabel.frame.minX - smallIndent - buttonWidth, y: smallIndent, width: buttonWidth, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        likeButtonFrame()
        countLikesLabelFrame()
        commentButtonFrame()
        countCommentsLabelFrame()
        repostsButtonFrame()
        countRepostsLabelFrame()
        viewImageFrame()
        countViewsLabelFrame()
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
    
    func configure(news: NewViewModel) {
        countLikesLabel.text = news.likesCount
                 countViewsLabel.text = news.viewsCount
                 countRepostsLabel.text = news.repostsCount
                 countCommentsLabel.text = news.commentsCount
                 likeFlag = news.likeFlag
                 likeButton.setImage(news.likeButtonImage, for: .normal)
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

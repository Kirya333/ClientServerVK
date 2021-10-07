//
//  GroupTableViewCell.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 15.07.2021.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func setup() {
        
    }
    
    func configure(group:GroupModel) {
        nameLabel.text = group.name
        avatarImageView.sd_setImage(with: URL(string: group.avatar), placeholderImage: UIImage(named: "community"))
    }
    
    func clearCell() {
        avatarImageView.image = nil
        nameLabel.text = nil
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

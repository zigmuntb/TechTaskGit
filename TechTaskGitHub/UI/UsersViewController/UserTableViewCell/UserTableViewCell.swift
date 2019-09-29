//
//  UserTableViewCell.swift
//  TechTaskGitHub
//
//  Created by Arsenkin Bogdan on 9/26/19.
//  Copyright © 2019 Arsenkin Bogdan. All rights reserved.
//

import UIKit
import SDWebImage

class UserTableViewCell: UITableViewCell {

	//MARK: - IBOutlets
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
	//MARK: - NSObject
	override func awakeFromNib() {
        super.awakeFromNib()
		
		nameLabel.text = String()
		logoImageView.layer.cornerRadius = min(logoImageView.frame.height, logoImageView.frame.width) / 2
		logoImageView.layer.masksToBounds = true
	}
	
	func fill(with model: UserInfoModel) {
		let url = URL(string: model.avatarUrl)
		logoImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
		logoImageView.sd_setImage(with: url, completed: nil)
		
		nameLabel.text = model.login
	}
}

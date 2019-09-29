//
//  RepositoryTableViewCell.swift
//  TechTaskGitHub
//
//  Created by Arsenkin Bogdan on 9/27/19.
//  Copyright © 2019 Arsenkin Bogdan. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        
		nameLabel.text = String()
    }
    
	
	func fill(with model: UserReposModel) {
		
		nameLabel.text = model.name
		descriptionLabel.text = model.projectDescription
	}
}

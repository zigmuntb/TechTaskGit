//
//  UserReposModel.swift
//  TechTaskGitHub
//
//  Created by Arsenkin Bogdan on 9/27/19.
//  Copyright © 2019 Arsenkin Bogdan. All rights reserved.
//

import UIKit
import RealmSwift

class UserReposModel: Object {
	@objc dynamic var name = String()
	@objc dynamic var projectDescription = String()
	@objc dynamic var htmlUrl = String()
}

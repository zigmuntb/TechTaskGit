//
//  UserInfoModel.swift
//  TechTaskGitHub
//
//  Created by Arsenkin Bogdan on 9/26/19.
//  Copyright © 2019 Arsenkin Bogdan. All rights reserved.
//

import UIKit
import RealmSwift

final class UserInfoModel: Object {

	@objc dynamic var login = String()
	@objc dynamic var avatarUrl = String()
	@objc dynamic var reposUrl = String()
	
}

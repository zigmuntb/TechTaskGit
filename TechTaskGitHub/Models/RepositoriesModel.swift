//
//  RepositoriesModel.swift
//  TechTaskGitHub
//
//  Created by Arsenkin Bogdan on 9/29/19.
//  Copyright © 2019 Arsenkin Bogdan. All rights reserved.
//

import UIKit
import RealmSwift

final class RepositoriesModel: Object {
	@objc dynamic var reposUrl = String()
	var repos = List<UserReposModel>()
}

//
//  RepositoriesViewController.swift
//  TechTaskGitHub
//
//  Created by Arsenkin Bogdan on 9/27/19.
//  Copyright © 2019 Arsenkin Bogdan. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class RepositoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private let cellIdentifier = String(describing: RepositoryTableViewCell.self)
	var userReposModelArray = [UserReposModel]()
	let realm = try! Realm()
	
	//MARK: - IBOutlets
	@IBOutlet weak var tableView: UITableView!
	
	//MARK: - Initialization
	init(model: RepositoriesModel) {
		super.init(nibName: nil, bundle: nil)
		
		userReposModelArray = Array(model.repos)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - UIViewController
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
	
	//MARK: - TableView methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		userReposModelArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RepositoryTableViewCell
		
		cell.fill(with: userReposModelArray[indexPath.row])
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let url = URL(string: userReposModelArray[indexPath.row].htmlUrl) else { return }
		
		if UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url)
		}
	}
	
	//MARK: - Private
	private func setupUI() {
		title = "Repositories"
	}
}

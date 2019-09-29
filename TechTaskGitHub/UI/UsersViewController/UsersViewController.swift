//
//  UsersViewController.swift
//  TechTaskGitHub
//
//  Created by Arsenkin Bogdan on 9/26/19.
//  Copyright © 2019 Arsenkin Bogdan. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

final class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	private let cellIdentifier = String(describing: UserTableViewCell.self)
	var userInfoModelArray = [UserInfoModel]()
	let realm = try! Realm()
	
	//MARK: - IBOutlets
	@IBOutlet weak var tableView: UITableView!
	
	//MARK: - Initialization
	init() {
		super.init(nibName: nil, bundle: nil)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - UIViewController
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		makeDecicsion()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
	}
	
	//MARK: - TableView methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return userInfoModelArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
		
		cell.fill(with: userInfoModelArray[indexPath.row])
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let currentUrl = userInfoModelArray[indexPath.row].reposUrl
		reposMakeDecision(url: currentUrl)
		
	}
	
	func reposMakeDecision(url: String) {
		let repos = Array(realm.objects(RepositoriesModel.self).filter("reposUrl = '\(url)'"))
		
		if repos.isEmpty {
			if let url = URL(string: url) {
				requestRepos(with: url)
			}
		} else {
			if let model = repos.first {
				self.navigationController?.pushViewController(RepositoriesViewController(model: model), animated: true)
			}
			
		}
	}
	
	
	
	//MARK: - URL request and append methods
	func requestRepos(with url: URL) {
		URLSession.shared.dataTask(with: url, completionHandler: { maybeData, maybeResponse, maybeError in
			if let error = maybeError {
				self.showErrorAlert(errorMessage: error.localizedDescription)
				return
			}
			
			guard let data = maybeData else {
				self.showErrorAlert(errorMessage: "No data!")
				return
			}
			
			guard let httpResponse = maybeResponse as? HTTPURLResponse else {
				self.showErrorAlert(errorMessage: "No response object")
				return
			}
			
			guard httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 else {
				self.showErrorAlert(errorMessage: httpResponse.statusCode.description)
				return
			}
			
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
				let data: JSON = JSON(json)
				
				
				self.parsingData(with: data, url: url.absoluteString)
				
				print(json)
			} catch let error {
				print("Error serializing json data: \(error.localizedDescription)")
			}
		}).resume()
	}
	
	func parsingData(with json: JSON, url: String) {
		guard let array = json.arrayObject as? [[String : Any]] else { return }
		let reposModel = RepositoriesModel()
		reposModel.reposUrl = url
		
		for data in array {
			let userReposModel = UserReposModel()
			
			userReposModel.name = data["name"] as? String ?? String()
			userReposModel.projectDescription = data["description"] as? String ?? String()
			userReposModel.htmlUrl = data["html_url"] as? String ?? String()
			
			reposModel.repos.append(userReposModel)
		}
		
		DispatchQueue.main.async {
			try! self.realm.write {
				self.realm.add(reposModel)
			}
			
			self.navigationController?.pushViewController(RepositoriesViewController(model: reposModel), animated: true)
		}
		
	}
	
	func requestData(with url: URL) {
		URLSession.shared.dataTask(with: url, completionHandler: { maybeData, maybeResponse, maybeError in
			if let error = maybeError {
				self.showErrorAlert(errorMessage: error.localizedDescription)
				return
			}
			
			guard let data = maybeData else {
				self.showErrorAlert(errorMessage: "No data!")
				return
			}
			
			guard let httpResponse = maybeResponse as? HTTPURLResponse else {
				self.showErrorAlert(errorMessage: "No response object.")
				return
			}
			
			guard httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 else {
				self.showErrorAlert(errorMessage: httpResponse.statusCode.description)
				return
			}
			
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
				let data : JSON = JSON(json)
				
				
				self.parsingUser(with: data)
				
				print(json)
			} catch let error {
				print("Error serializing json data: \(error.localizedDescription)")
			}
		}).resume()
	}
	
	func parsingUser(with json: JSON) {
		guard let array = json.arrayObject as? [[String : Any]] else { return }
		
		for data in array {
			let userinfoModel = UserInfoModel()
			
			userinfoModel.login = data["login"] as? String ?? String()
			userinfoModel.avatarUrl = data["avatar_url"] as? String ?? String()
			userinfoModel.reposUrl = data["repos_url"] as? String ?? String()
			
			DispatchQueue.main.async {
				try! self.realm.write {
					self.realm.add(userinfoModel)
				}
			}
			
			userInfoModelArray.append(userinfoModel)
		}
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
		
		print()
	}
	
	//MARK: - Private
	private func setupUI() {
		title = "Users"
	}
	
	private func makeDecicsion() {
		let models = Array(realm.objects(UserInfoModel.self))
		
		if models.count == 0 {
			guard let url = URL(string: Constant.gitUsersUrl) else { return }
			
			requestData(with: url)
		} else {
			userInfoModelArray = models
			tableView.reloadData()
		}
	}
	
	private func showErrorAlert(errorMessage: String) {
		let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		
		alertController.addAction(okAction)
		
		DispatchQueue.main.async {
			self.present(alertController, animated: true, completion: nil)
		}
	}
}



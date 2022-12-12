//
//  SecondViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var feed: [String]! = ["Hello world", "Here's another one", "There' something hiddne about the fact that this is not what i intended to do, but it happening anyway"]
  
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
		let tabImage = UIImage(named: "home")
		tabImage?.withTintColor(Color.homeTabLight, renderingMode: .alwaysTemplate)
		self.tabBarItem = UITabBarItem(title: "", image: tabImage, tag: 1)
		self.tabBarItem.setBadgeTextAttributes([NSAttributedString.Key.backgroundColor: Color.red, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)], for: .normal)

		
		let feedTable = initFeedTableView()
		self.view.addSubviews(views: feedTable)
		self.view.constrain(type: .horizontalFill, feedTable)
		self.view.addConstraints(format: "V:|-0-[v0]-0-|", views: feedTable)
        
        Linker(path: "/posts") {
            data, response, error in
            if let json = data?.toJsonArray() {
                for post in json {
                    let value = (post as! Dictionary<String, Any>)["body"] as! String
                    self.feed.append(value.replacingOccurrences(of: "\n", with: ""))
                }
            }
            DispatchQueue.main.async {
                feedTable.reloadData()
            }
            
        }.execute()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		self.view.backgroundColor = Color.background

	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.title = "Feed"
    }
	
	func initFeedTableView() -> UITableView {
		let tableView = UITableView()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.backgroundColor = Color.background
        tableView.separatorColor = UIColor.clear
		return tableView
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return feed.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedCell = FeedCell(feed[indexPath.row])
		let background = UIView()
		background.backgroundColor = Color.create(UIColor(hex: 0xf0f0f0), dark: UIColor(hex: 0x000000))
		cell.selectedBackgroundView = background
        if indexPath.row == feed.count - 1 {
            cell.hideSeparator()
        }
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.presentMessages()
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func makeFeedAcitivityCounter() -> UIView {
		let container = UIView()
		container.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
		container.layer.cornerRadius = 15
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 17)
		label.textColor = UIColor.systemBackground
		label.text = "23"
		label.textAlignment = .center
		container.addSubview(label)
		container.addConstraints(format: "V:|-4-[v0(22)]-4-|", views: label)
		container.addConstraints(format: "H:|-4-[v0(>=22)]-4-|", views: label)
		label.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
		container.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
		return container
	}
	
	@objc func presentMessages() {
		let messagesVC = MessagesViewController()
		messagesVC.modalPresentationStyle = .fullScreen
		self.navigationController?.pushViewController(messagesVC, animated: true)
	}
}

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
		
		let counter = self.makeFeedAcitivityCounter()
		
		let feedTable = initFeedTableView()
		self.view.addSubviews(views: feedTable, counter)
		self.view.constrain(type: .horizontalFill, feedTable)
		self.view.addConstraints(format: "V:|-0-[v0]-0-|", views: feedTable)
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
			let image = counter.getImage()!.withRenderingMode(.alwaysOriginal)
			self.tabBarItem.image = image
			counter.isHidden = true
		})
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		self.view.backgroundColor = Color.background

	}
	
	func initFeedTableView() -> UITableView {
		let tableView = UITableView()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.backgroundColor = Color.background
		tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 16)
		return tableView
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return feed.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = FeedCell(feed[indexPath.row])
		let background = UIView()
		background.backgroundColor = Color.create(UIColor(hex: 0xf0f0f0), dark: UIColor(hex: 0x000000))
		cell.selectedBackgroundView = background
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


class FeedCell: UITableViewCell {
	var feed: String!
	
	init(_ feed: String) {
		super.init(style: .default, reuseIdentifier: .none)
		self.feed = feed
		
		let ownerImage = makeOwnerImage()
		let ownerName = UILabel("Simone biles", Color.darkBlue, UIFont.systemFont(ofSize: 17, weight: .bold))
		let feedTime = UILabel("2d ago", Color.darkBlue, UIFont.italicSystemFont(ofSize: 12))
		let feedBody = UILabel(feed, Color.textDark, UIFont.systemFont(ofSize: 16))
		feedBody.numberOfLines = 6
		
		let ownerContainer = UIView()
		ownerContainer.addSubviews(views: ownerName, feedTime)
		ownerContainer.addConstraints(format: "V:|-2-[v0(24)]-2-|", views: ownerName)
		ownerContainer.addConstraints(format: "V:|-2-[v0(24)]-2-|", views: feedTime)
		ownerContainer.addConstraints(format: "H:|-0-[v0]-0-[v1(40@1)]-0-|", views: ownerName, feedTime)
		
		let feedActivityCounter = makeFeedAcitivityCounter()
		let feedActivitySummary = UILabel("are talking about this", Color.purple, UIFont.systemFont(ofSize: 12))
		let feedActivityContainer = UIView()
		feedActivityContainer.addSubviews(views: feedActivityCounter, feedActivitySummary)
		feedActivityContainer.addConstraints(format: "V:|-2-[v0]-2-|", views: feedActivityCounter)
		feedActivityContainer.addConstraints(format: "H:|-0-[v0(>=12,<=35)]-4-[v1]-0-|", views: feedActivityCounter, feedActivitySummary)
		feedActivitySummary.centerYAnchor.constraint(equalTo: feedActivityContainer.centerYAnchor).isActive = true
		
		
		let bodyContainer = UIView()
		bodyContainer.addSubviews(views: ownerContainer, feedBody, feedActivityContainer)
		bodyContainer.addConstraints(format: "V:|-8-[v0]-0-[v1]-8-[v2]-8-|", views: ownerContainer, feedBody, feedActivityContainer)
		bodyContainer.constrain(type: .horizontalFill, ownerContainer, feedBody, feedActivityContainer)
		
		let feedContainer = UIView()
		feedContainer.addSubviews(views: ownerImage, bodyContainer)
		feedContainer.addConstraints(format: "V:|-16-[v0(40)]-(>=0)-|", views: ownerImage)
		feedContainer.addConstraints(format: "V:|-0-[v0]-8-|", views: bodyContainer)
		feedContainer.addConstraints(format: "H:|-0-[v0(40)]-8-[v1]-0-|", views: ownerImage, bodyContainer)
		
		self.contentView.addSubview(feedContainer)
		self.contentView.backgroundColor = UIColor.clear
		self.contentView.constrain(type: .horizontalFill, feedContainer, margin: 16)
		self.contentView.constrain(type: .verticalFill, feedContainer, margin: 2)
		self.backgroundColor = Color.background
		
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func makeOwnerImage() -> UIImageView {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = 12
		imageView.clipsToBounds = true
		imageView.backgroundColor = Color.red
		return imageView
	}
  
	func makeFeedAcitivityCounter() -> UIView {
		let container = UIView()
		container.backgroundColor = Color.purple
		container.layer.cornerRadius = 8
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 10)
		label.textColor = UIColor.systemBackground
		label.text = "2.3k"
		container.addSubview(label)
		container.constrain(type: .horizontalFill, label, margin: 6)
		container.constrain(type: .verticalFill, label, margin: 2)
		return container
	}
	
	
}

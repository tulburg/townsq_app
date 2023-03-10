//
//  SecondViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class FeedViewController: ViewController, UITableViewDelegate, UITableViewDataSource, SocketDelegate {
	
	var feed: [Broadcast] = []
    var feedMeta: [FeedCellMeta] = []
    var tableView: UITableView!
    var initialized = false
  
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
        
        self.feed = DB.fetchFeed()
        Socket.shared.fetchFeed()
        initialized = true
        populateMeta()
        
//        ImageCache.shared().drop()
//        DB.shared.drop(.Comment)
//        DB.shared.drop(.Broadcast)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		self.view.backgroundColor = Color.background
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.title = "Feed"
        Socket.shared.registerDelegate(self)
        
        self.feed = DB.fetchFeed()
        tableView.reloadData()
        populateMeta()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
//        Socket.shared.unregisterDelegate(self)
    }
    
    func populateMeta() {
        self.feed.forEach {_ in
            let meta = FeedCellMeta()
            meta.size = CGSize(width: 0, height: 0)
            self.feedMeta.append(meta)
        }
    }
	
	func initFeedTableView() -> UITableView {
		tableView = UITableView()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.backgroundColor = Color.background
        tableView.separatorColor = UIColor.clear
        tableView.register(FeedCell.self, forCellReuseIdentifier: "feed_cell")
        tableView.register(FeedCell.self, forCellReuseIdentifier: "feed_cell_with_media")
		return tableView
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return feed.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let broadcast = feed[indexPath.row]
        let meta = feedMeta[indexPath.row]
        var cell: FeedCell!
        if broadcast.media != nil && MediaType(rawValue: broadcast.media_type!) == .photo {
            cell = tableView.dequeueReusableCell(withIdentifier: "feed_cell_with_media") as? FeedCell
        }else {
            cell = tableView.dequeueReusableCell(withIdentifier: "feed_cell") as? FeedCell
        }
        cell.setup(broadcast, meta)
		let background = UIView()
        background.backgroundColor = Color.create(0xf0f0f0, dark: 0x000000)
		cell.selectedBackgroundView = background
        cell.onOpen = { [self] in
            let vc = ProfileViewController()
            vc.external = true
            vc.view.showIndicator(size: .large, color: Color.darkBlue)
            Socket.shared.fetchUser(broadcast.user!)
            Socket.shared.registerDelegate(vc as SocketDelegate)
            vc.user = broadcast.user
            present(vc, animated: true)
        }
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messagesVC = MessagesViewController()
        messagesVC.modalPresentationStyle = .fullScreen
        messagesVC.broadcast = feed[indexPath.row]
        messagesVC.feedMeta = feedMeta[indexPath.row]
        self.navigationController?.pushViewController(messagesVC, animated: true)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func makeFeedAcitivityCounter() -> UIView {
		let container = UIView()
		container.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
		container.layer.cornerRadius = 15
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 17)
		label.textColor = UIColor.systemBackground
		label.text = "3"
		label.textAlignment = .center
		container.addSubview(label)
		container.addConstraints(format: "V:|-4-[v0(22)]-4-|", views: label)
		container.addConstraints(format: "H:|-4-[v0(>=22)]-4-|", views: label)
		label.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
		container.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
		return container
	}
    
    func socket(didReceive event: Constants.Events, data: ResponseData) {
        if event == .GotUser {
            if let broadcast = data as? DataType.BroadcastUpdate {
                if broadcast.id == broadcast.id {
                    tableView.reloadData()
                }
            }
        }
        
        if event == .GotBroadcast {
            self.feed = DB.fetchFeed()
            tableView.reloadData()
            populateMeta()
        }
        
        if event == .GotFeed {
            self.feed = DB.fetchFeed()
            tableView.reloadData()
            populateMeta()
        }
    }
}

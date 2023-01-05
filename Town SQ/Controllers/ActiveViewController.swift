//
//  ActiveViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 09/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class ActiveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
  
    var activeBroadcasts: [Broadcast] = []
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        activeBroadcasts = DB.activeBroadcasts()!
        
        let tabImage = UIImage(named: "active")
        tabImage?.withTintColor(Color.tabItemDisabled, renderingMode: .alwaysTemplate)
        self.tabBarItem = UITabBarItem(title: "", image: tabImage, tag: 1)
        
        let table = initTableView()
        self.view.addSubviews(views: table)
        self.view.constrain(type: .horizontalFill, table)
        self.view.addConstraints(format: "V:|-0-[v0]-0-|", views: table)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.title = "Active"
        (self.tabBarController as! TabBarController).activeBadge?.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        (self.tabBarController as! TabBarController).activeBadge?.isHidden = false
    }
    
    func initTableView() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.backgroundColor = Color.background
        tableView.separatorColor = UIColor.clear
        tableView.register(FeedCell.self, forCellReuseIdentifier: "feed_cell_as_active")
        return tableView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeBroadcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedCell = tableView.dequeueReusableCell(withIdentifier: "feed_cell_as_active") as! FeedCell
        cell.setup(activeBroadcasts[indexPath.row])
        let background = UIView()
        background.backgroundColor = Color.create(0xf0f0f0, dark: 0x000000)
        cell.selectedBackgroundView = background
        if indexPath.row == activeBroadcasts.count - 1 {
            cell.hideSeparator()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messagesVC = MessagesViewController()
        messagesVC.modalPresentationStyle = .fullScreen
        messagesVC.broadcast = activeBroadcasts[indexPath.row]
        self.navigationController?.pushViewController(messagesVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

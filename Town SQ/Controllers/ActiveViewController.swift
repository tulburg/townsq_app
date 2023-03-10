//
//  ActiveViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 09/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class ActiveViewController: UIViewController, SocketDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var activeBroadcasts: [Broadcast] = []
    var feedMeta: [FeedCellMeta] = []
    var tableView: UITableView!
    var hasUnread = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        activeBroadcasts = DB.activeBroadcasts()!
        populateMeta()
        hasUnread = activeBroadcasts.filter{ return $0.unread > 0 }.count > 0
        
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
        
        self.activeBroadcasts = DB.activeBroadcasts()!
        self.tableView.reloadData()
        self.populateMeta()
        Socket.shared.registerDelegate(self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        (self.tabBarController as! TabBarController).activeBadge?.isHidden = !hasUnread
        
        Socket.shared.unregisterDelegate(self)
    }
    
    func initTableView() -> UITableView {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.backgroundColor = Color.background
        tableView.separatorColor = UIColor.clear
        tableView.register(FeedCell.self, forCellReuseIdentifier: "feed_cell_as_active")
        tableView.register(FeedCell.self, forCellReuseIdentifier: "feed_cell_as_active_with_media")
        return tableView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeBroadcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let broadcast = activeBroadcasts[indexPath.row]
        var cell: FeedCell!
        if broadcast.media != nil && broadcast.media_type != nil {
            cell = tableView.dequeueReusableCell(withIdentifier: "feed_cell_as_active_with_media") as? FeedCell
        }else {
            cell = tableView.dequeueReusableCell(withIdentifier: "feed_cell_as_active") as? FeedCell
        }
        cell.setup(broadcast, feedMeta[indexPath.row])
        let background = UIView()
        background.backgroundColor = Color.create(0xf0f0f0, dark: 0x000000)
        cell.selectedBackgroundView = background
        if indexPath.row == activeBroadcasts.count - 1 {
            cell.hideSeparator()
        }
        cell.onLeave = {
            Socket.shared.leaveBroadcast(broadcast)
            broadcast.joined = nil
            broadcast.active = BroadcastType.Normal.rawValue
            DB.shared.save()
            DispatchQueue.main.async { [self] in
                activeBroadcasts.remove(at: indexPath.row)
                feedMeta.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messagesVC = MessagesViewController()
        messagesVC.modalPresentationStyle = .fullScreen
        messagesVC.broadcast = activeBroadcasts[indexPath.row]
        messagesVC.feedMeta = feedMeta[indexPath.row]
        self.navigationController?.pushViewController(messagesVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func socket(didReceive event: Constants.Events, data: ResponseData) {
        if event == .GotUser {
            tableView.reloadData()
        }
        
        if event == .GotComment {
            tableView.reloadData()
            hasUnread = true
        }
    }
    
    func socket(didMarkUnread broadcast: Broadcast) {
        tableView.reloadData()
    }
    
    func populateMeta() {
        self.activeBroadcasts.forEach {_ in
            let meta = FeedCellMeta()
            meta.size = CGSize(width: 0, height: 0)
            self.feedMeta.append(meta)
        }
    }
}

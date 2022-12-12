//
//  ActiveViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 09/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class ActiveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var feed: [String]! = ["Hello world", "Here's another one", "There' something hiddne about the fact that this is not what i intended to do, but it happening anyway"]
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let tabImage = UIImage(named: "active")
        tabImage?.withTintColor(Color.tabItemDisabled, renderingMode: .alwaysTemplate)
        self.tabBarItem = UITabBarItem(title: "", image: tabImage, tag: 1)
        self.tabBarItem.setBadgeTextAttributes([NSAttributedString.Key.backgroundColor: Color.red, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)], for: .normal)
        
        let table = initTableView()
        self.view.addSubviews(views: table)
        self.view.constrain(type: .horizontalFill, table)
        self.view.addConstraints(format: "V:|-0-[v0]-0-|", views: table)
        
        Linker(path: "/posts") {
            data, response, error in
            if let json = data?.toJsonArray() {
                for post in json {
                    let value = (post as! Dictionary<String, Any>)["body"] as! String
                    self.feed.append(value.replacingOccurrences(of: "\n", with: ""))
                }
            }
            DispatchQueue.main.async {
                table.reloadData()
            }
            
        }.execute()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.title = "Active"
    }
    
    func initTableView() -> UITableView {
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
        let cell: FeedCell = FeedCell(feedText: feed[indexPath.row], 3)
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
    
    @objc func presentMessages() {
        let messagesVC = MessagesViewController()
        messagesVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(messagesVC, animated: true)
    }
}

//
//  SearchViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 09/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class SearchViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var searchController: UISearchController!
    
    let data = [
        "Hi, Please restore my account. My account couldn't have violated any policy. It may look like that because I only",
        "Limiting your social media use to just 30 minutes a day can decrease feelings of loneliness and depression"
    ]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let tabImage = UIImage(named: "search")
        tabImage?.withTintColor(Color.tabItemDisabled, renderingMode: .alwaysTemplate)
        self.tabBarItem = UITabBarItem(title: "", image: tabImage, tag: 1)
        self.tabBarItem.setBadgeTextAttributes([NSAttributedString.Key.backgroundColor: Color.red, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)], for: .normal)
        
        searchController = UISearchController()
        searchController.searchBar.layer.shadowOpacity = 0.0
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        searchController.searchBar.backgroundColor = Color.background
    
        tableView = UITableView()
        tableView.tableHeaderView = searchController.searchBar
        tableView.delegate = self
        tableView.backgroundColor = Color.background
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.dataSource = self
        view.add().vertical(0).view(tableView).end(">=0")
        view.constrain(type: .horizontalFill, tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.title = "Explore"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FeedCell(feedText: data[indexPath.row], nil)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

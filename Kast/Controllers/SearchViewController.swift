//
//  SearchViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 09/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class SearchViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rootView: UITableView!
    var searchController: UISearchController!
    
    let data = [
        "One", "Two", "Hi, Please restore my account. My account couldn't have violated any policy. It may look like that because I only",
        "Hi, Please restore my account. My account couldn't have violated any policy. It may look like that because I only",
        "Hi, Please restore my account. My account couldn't have violated any policy. It may look like that because I only",
        "Hi, Please restore my account. My account couldn't have violated any policy. It may look like that because I only",
        "Hi, Please restore my account. My account couldn't have violated any policy. It may look like that because I only",
        "Hi, Please restore my account. My account couldn't have violated any policy. It may look like that because I only",
        "Hi, Please restore my account. My account couldn't have violated any policy. It may look like that because I only",
        "Hi, Please restore my account. My account couldn't have violated any policy. It may look like that because I only",
        "Hi, Please restore my account. My account couldn't have violated any policy. It may look like that because I only",
        "Hi, Please restore my account. My account couldn't have violated any policy. It may look like that because I only",
        "Hi, Please restore my account. My account couldn't have violated any policy. It may look like that because I only",
        "Hi, Please restore my account. My account couldn't have violated any policy. It may look like that because I only",
        "Hi, Please restore my account. My account couldn't have violated any policy. It may look like that because I only"
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
        
//        navigationItem.searchController = searchController
    
        rootView = UITableView()
        rootView.tableHeaderView = searchController.searchBar
        rootView.delegate = self
        rootView.backgroundColor = Color.background
        rootView.dataSource = self
        view.add().vertical(0).view(rootView).end(0)
        view.constrain(type: .horizontalFill, rootView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for c in searchController.searchBar.constraints {
            print(c)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.title = "Explore"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.numberOfLines = 3
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
